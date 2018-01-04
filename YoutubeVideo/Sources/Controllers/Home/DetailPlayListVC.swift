//
//  DetailPlayListVC.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/3/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

private let playListCellId = "playListCell"


class DetailPlayListVC: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Variables
    
    var playlistTitle: String!
    var playlistId: String!
    
    var data: [Video] = []
    
    var maxResults = 5
    var isFull = false
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
   
        requestApi(maxResults)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(red: 36/255, green: 38/255, blue: 41/255, alpha: 1)
        self.title = playlistTitle
        
        configureCollection()
    }
    
    //MARK: - Call API
    
    func requestApi(_ maxResults: Int){
        
        let url = "https://www.googleapis.com/youtube/v3/playlistItems"
        
        let params: Parameters = ["part": "snippet,contentDetails",
                                  "maxResults": maxResults,
                                  "key": API_KEY,
                                  "playlistId": playlistId]

//        Alamofire
//            .request(url, method: .get, parameters: params)
//            .responseArray(keyPath: "items") {[weak self] (response: DataResponse<[Video]>) in
//
//                guard let strongSelf = self else { return }
//
//                if let error = response.error {
//                    print(error)
//                }
//
//                guard let video = response.result.value else {
//                    print("112312312")
//                    return
//                }
//
//                strongSelf.currentOffset += 5
//
//                strongSelf.data = video
//                strongSelf.collectionView.reloadData()
//
//        }
        self.isFull = false
        
        Alamofire
            .request(url, method: .get, parameters: params)
            .responseObject {[weak self] (response: DataResponse<ResponseVideo>) in
                
                guard let strongSelf = self else { return }
                
                if let error = response.error {
                    print(error)
                }
                
                guard let res = response.result.value else {
                    print("112312312")
                    return
                }
                
                if strongSelf.data.count < res.totalResults! {
                    strongSelf.maxResults += 1
                    print(strongSelf.data.count)
                }else{
                    strongSelf.isFull = true
                }
                
                strongSelf.data = res.items!
                strongSelf.collectionView.reloadData()
        }
        
    }
    
    func configureCollection(){
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.registerNib(PlayListCollectionViewCell.self, playListCellId)
        collectionView.registerNib(LoadingCell.self, loadingCellId)
        
        collectionView.reloadData()
    }


}

//MARK: - tableview datasource

extension DetailPlayListVC: UICollectionViewDataSource {
    
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: playListCellId , for: indexPath) as! PlayListCollectionViewCell
        
        cell.configure(data[indexPath.row])
        
        return cell
    }
}

//MARK: - TableView Delegate

extension DetailPlayListVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 380, height: 210)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            
            if !isFull && !isFull && maxResults != 0{
                
                requestApi(maxResults)
                
            }
            
        }
        
    }
}









