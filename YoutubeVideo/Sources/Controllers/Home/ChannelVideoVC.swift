//
//  ChannelVideoVC.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/4/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

private let videoChannelCellId = "videoChannelCell"

class ChannelVideoVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Variables
    
    var channelId: String!
    var channelTitle: String!
    
    var data = [Video]()

    var isFull = false
    var pageToken = ""
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        requestApi()
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(red: 36/255, green: 38/255, blue: 41/255, alpha: 1)
        
        self.title = channelTitle
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.registerNib(VideoChannelCollectionCell.self, videoChannelCellId)
        collectionView.registerNib(LoadingCell.self, loadingCellId)
        
        collectionView.reloadData()
    }
    
    //MARK: - Call API
    
    func requestApi(){
        
        let url = "https://www.googleapis.com/youtube/v3/activities"
        
        let params: Parameters = ["part": "snippet,contentDetails",
                                  "key": API_KEY,
                                  "maxResults": 20,
                                  "channelId": channelId,
                                  "pageToken": pageToken]
        
        Alamofire
            .request(url, method: .get, parameters: params)
            .responseObject {[weak self] (response: DataResponse<ResponseVideo>) in
                
                guard let strongSelf = self else {
                    return
                }
                
                if let error = response.result.error{
                    print(error)
                }
                
                guard let res = response.result.value else{
                    return print("1312321321312")
                }
                
                if let video = res.items {
                    
                    if video.count < 20 {
                        strongSelf.isFull = true
                    }
                    
                    strongSelf.pageToken = res.nextPageToken ?? ""
                    strongSelf.data.append(contentsOf: video)
                    strongSelf.collectionView.reloadData()
                }      
                
        }
        
    }


}


//MARK: - CollectionView DataSource

extension ChannelVideoVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if isFull {
            return 1
        }
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 1 {
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: videoChannelCellId, for: indexPath) as! VideoChannelCollectionCell
        
        let item = data[indexPath.row]
        
        cell.configure(item.title, item.thumbnails)
        
        return cell
    }
}

//MARK: - CollectionView Delegate

extension ChannelVideoVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 380, height: 210)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            
            if !isFull{
                
                requestApi()
                
            }
            
        }
        
    }
}









