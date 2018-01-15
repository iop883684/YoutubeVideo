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
import XCDYouTubeKit
import FirebaseFirestore

private let searchCellId = "searchCell"
private let keyCellId = "keyCell"

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
    
    var isSearching = true
    var isHaveUrl = false
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
        collectionView.registerNib(KeyCollectionViewCell.self, keyCellId)
        
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
                                  "regionCode": regionCode,
                                  "type": "video"]
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? VideoPlayerVC {
            
            let indexPath = sender as! IndexPath
            
            vc.videoTitle = data[indexPath.row].title
        }
    }
}


//MARK: - Collection Datasource

extension SearchVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if !isSearching {
            if isFull{
                return 1
            }
            return 2
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !isSearching {
            if  section == 1{
                return 1
            }
            
            return data.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if !isSearching {
            if indexPath.section == 1 {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: loadingCellId, for: indexPath) as! LoadingCell
                cell.indicator.startAnimating()
                return cell
                
            }
            
            let item = data[indexPath.row]
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchCellId, for: indexPath) as! SearchCollectionViewCell
            
            cell.configure(item)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: keyCellId, for: indexPath) as! KeyCollectionViewCell
            
            return cell
        }
    }
}

//MARK: - Collection Delegate

extension SearchVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if !isSearching {
            if indexPath.section == 1 {
                return CGSize(width: UIScreen.main.bounds.width, height: 50)
            }else {
                return CGSize(width: 340, height: 210)
            }
        } else {
            return CGSize(width: UIScreen.main.bounds.width, height: 200)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = data[indexPath.row]
        
        Global.shared.idChannel = ""
        Global.shared.titleChannel = ""
        Global.shared.thumbChannel = ""
        Global.shared.titlePlaylist = ""
        
        Global.shared.idChannel = item.channelId
        Global.shared.titleChannel = item.channelTitle
        Global.shared.thumbChannel = item.thumbnails
        Global.shared.titlePlaylist = item.title
        
        UrlVideo.small = nil
        UrlVideo.hd = nil
        UrlVideo.medium = nil
        
        XCDYouTubeClient.default().getVideoWithIdentifier(item.videoId) {  [weak self] (video: XCDYouTubeVideo?, error: Error?) in
            
            guard let strongSelf = self else { return }
            
            if let err = error {
                print("error:", err.localizedDescription)
                return
            }
            
            guard let streamURLs = video?.streamURLs else {
                print("no url found")
                return
            }
            
            var isHaveUrl = false
            
            if let hdURL = streamURLs[VideoQuality.hd720]  {
                UrlVideo.hd = hdURL
                isHaveUrl = true
            }
            
            if let mediumURL = streamURLs[VideoQuality.medium360]  {
                UrlVideo.medium = mediumURL
                isHaveUrl = true
            }
            
            if let mediumURL = streamURLs[VideoQuality.small240]  {
                UrlVideo.small = mediumURL
                isHaveUrl = true
            }
            
            if isHaveUrl {
                strongSelf.performSegue(withIdentifier: "sgVideoPlayer", sender: indexPath)
            } else{
                print("no url suitable")
            }
        }
    }
}


//MARK: - Search Bar Delegate

extension SearchVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        data.removeAll()
        requestAPI(searchBar.text!)
        isSearching = false
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        isSearching = true
        data.removeAll()
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
    }
    
}









