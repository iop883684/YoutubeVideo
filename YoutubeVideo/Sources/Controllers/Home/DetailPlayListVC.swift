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
import XCDYouTubeKit
import MobilePlayer

private let videoChannelCellId = "videoChannelCell"
private let playListCellId = "playListCell"

class DetailPlayListVC: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Variables
    
    var vcTitle: String!
    var id: String!

    var data: [Video] = []
    
    var nextPageToken = ""
    
    var isFull = false
    var isChannel: Bool!
    var isLoading = false
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        requestApi()

        self.title = vcTitle
        
        configureCollection()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.isStatusBarHidden = false
    }
    
    //MARK: - Call API
    
    func requestApi(){
        
        if isLoading{
            return
        }
        
        isLoading = true
        
        var url = ""
        
        if isChannel{
             url = "https://www.googleapis.com/youtube/v3/activities"
        } else {
             url = "https://www.googleapis.com/youtube/v3/playlistItems"
        }
        
        var params: Parameters = ["part": "snippet,contentDetails",
                                  "maxResults": 7,
                                  "type":"video",
                                  "key": API_KEY,
                                  "nextPageToken":nextPageToken]
        
        if isChannel {
            params["channelId"] = id
        }else {
            params["playlistId"] = id
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

    
    func playVideo(_ url: URL,_ title: String){
        
        let playerVC = MobilePlayerViewController(contentURL: url)
        playerVC.title = title
        playerVC.activityItems = [url] // Check the documentation for more information.
        self.present(playerVC, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? VideoPlayerVC{
            
            let indexPath = sender as! IndexPath

            vc.videoTitle = self.data[indexPath.row].title
        }
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
            return CGSize(width: 340, height: 210)
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
        
        let item = data[indexPath.row]
        
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
                strongSelf.performSegue(withIdentifier: "sgPlayer", sender: indexPath)
            } else{
                print("no url suitable")
            }
        }
    }
}









