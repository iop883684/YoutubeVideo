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
import PKHUD

private let videoChannelCellId = "videoChannelCell"
private let playListCellId = "playListCell"

class DetailPlayListVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var vcTitle: String!
    var itemId: String!

    private var data: [Video] = []
    private var nextPageToken = ""
    private var isFull = false
    private var isLoading = false
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = vcTitle
        configureCollection()
        
        requestApi()
    }

    
    //MARK: - Call API
    
    func requestApi(){
        
        if isLoading{
            return
        }
        
        isLoading = true
        
        var url = ""
        
        let isChannel = !itemId.contains("PL")
        print(itemId)

        if isChannel{
             url = "https://www.googleapis.com/youtube/v3/activities"
        } else {
             url = "https://www.googleapis.com/youtube/v3/playlistItems"
        }
        
        var params: Parameters = ["part": "snippet,contentDetails",
                                  "maxResults": 20,
                                  "type":"video",
                                  "key": API_KEY,
                                  "nextPageToken":nextPageToken]
        
        if isChannel {
            params["channelId"] = itemId
        }else {
            params["playlistId"] = itemId
        }

        Alamofire
            .request(url, method: .get, parameters: params)
            .responseObject {[weak self] (response: DataResponse<ResponseVideo>) in

                guard let strongSelf = self else { return }
                
                strongSelf.isLoading = false
                
                if let error = response.error {
                    print(error)
                }
                
                guard let res = response.result.value else {
                    print("no value")
                    return
                }
                
                if let video = res.items {
                    
                    if video.count < 20 {
                        strongSelf.isFull = true
                    }
                    
                    strongSelf.nextPageToken = res.nextPageToken ?? ""
                    strongSelf.data.append(contentsOf: video)
                    strongSelf.collectionView.reloadData()
                    
                }
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
        
        let item = data[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: playListCellId , for: indexPath) as! PlayListCollectionViewCell
            
        cell.configure(item)
            
        return cell
    }
}

//MARK: - TableView Delegate

extension DetailPlayListVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 1 {
            return CGSize(width: UIScreen.main.bounds.width, height: 50)
        }else {
            let width = UIScreen.main.bounds.size.width - 20
            let height = width/16*9
            return CGSize(width: width, height: height)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            if !isFull {
                requestApi()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "sgPlayer", sender: data[indexPath.row])

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? VideoPlayerVC{
            vc.videoObj = sender as! Video
        }
        
    }
    
}









