//
//  SearchVC.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/15/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

private let searchCellId = "searchCell"

private let width = UIScreen.main.bounds.width

class SearchVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Variables
    
    lazy var searchBar = UISearchBar()
    
    var data: [Video] = []

    var nextPageToken = ""
    var regionCode = "VN"
    var searchText = ""
    
    var isFull = false
    var isLoading = false
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = searchBar
        
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.registerNib(SearchCollectionViewCell.self, searchCellId)
        collectionView.registerNib(LoadingCell.self, loadingCellId)
    }
    
    @IBAction func tap(_ sender: UITapGestureRecognizer){
        
        self.searchBar.endEditing(true)
    }
    
    
    //MARK: - CaLL API
    
    func requestAPI(_ text: String){
        
        if isLoading{
            return
        }
        
        isLoading = true
        
        let url = "https://www.googleapis.com/youtube/v3/search"
        
        let params: Parameters = ["part": "snippet",
                                  "maxResults": 10,
                                  "q": text,
                                  "key": API_KEY,
                                  "pageToken":nextPageToken,
                                  "regionCode": regionCode]
        
        print(params)
        
        Alamofire
            .request(url, method: .get, parameters: params)
            .responseObject {[weak self] (res: DataResponse<ResponseVideo>) in
                
                guard let strongSelf = self else { return }
                
                strongSelf.isLoading = false
                
                if let error = res.error {
                    print(error)
                }
                
                guard let res = res.result.value else {
                    print("empty")
                    return
                }
                
                print(res)
                
                if let video = res.items {
                    
                    if video.count < 10 {
                        strongSelf.isFull = true
                    }
                    
                    strongSelf.regionCode = res.regionCode ?? ""
                    strongSelf.nextPageToken = res.nextPageToken ?? ""
                    strongSelf.data.append(contentsOf: video)
                    strongSelf.collectionView.reloadData()
                }
                
        }
    }

}


//MARK: - Collection Datasource

extension SearchVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if isFull{
            return 1
        }
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if  section == 1{
            return 1
        }
        
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 1 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: loadingCellId, for: indexPath) as! LoadingCell
            cell.indicator.startAnimating()
            return cell
            
        }
        
        let item = data[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchCellId, for: indexPath) as! SearchCollectionViewCell
        
        cell.configure(item)
        
        return cell
    }
}

//MARK: - Collection Delegate

extension SearchVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 1 {
            return CGSize(width: UIScreen.main.bounds.width, height: 50)
        }else {
            return CGSize(width: 340, height: 210)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            if !isFull && !isLoading {
                requestAPI(searchText)
            }
        }
    }
}


//MARK: - Search Bar Delegate

extension SearchVC: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        if searchBar.text != nil {
            data.removeAll()
            self.searchText = searchBar.text!
            requestAPI(searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
    }
    
}









