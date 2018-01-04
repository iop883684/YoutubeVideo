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
    
    var data: [Video] = []
    
    var maxResults = 5
    var isFull = false
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        requestApi(maxResults)
        
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
    
    func requestApi(_ maxResults: Int){
        
        let url = "https://www.googleapis.com/youtube/v3/activities"
        
        let params: Parameters = ["part": "snippet,contentDetails",
                                  "key": API_KEY,
                                  "maxResults": maxResults,
                                  "channelId": channelId]
        
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
                
                if maxResults < res.totalResults! {
                    strongSelf.maxResults += 1
                }else{
                    strongSelf.isFull = true
                }
                
                strongSelf.data = res.items!
                strongSelf.collectionView.reloadData()
                
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
            
            if !isFull && !isFull && maxResults != 0{
                
                requestApi(maxResults)
                
            }
            
        }
        
    }
}









