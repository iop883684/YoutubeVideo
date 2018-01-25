//
//  VideoPlayerVC.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/8/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit
import XCDYouTubeKit
import BMPlayer
import PKHUD
import Alamofire
import AlamofireObjectMapper

class VideoPlayerVC: UIViewController{
    
    struct VideoQuality {
        static let hd720 = NSNumber(value: XCDYouTubeVideoQuality.HD720.rawValue)
        static let medium360 = NSNumber(value: XCDYouTubeVideoQuality.medium360.rawValue)
        static let small240 = NSNumber(value: XCDYouTubeVideoQuality.small240.rawValue)
    }
    
    @IBOutlet weak var moreBtn: UIButton!
    
    var videoObj:Video!
    
    var id = ""
    
    private var videoTitle: String!
    private var player: BMPlayer!
    private var isFollow = false
    private var controller: BMPlayerCustomControlView? = nil
    private var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if id != "" {
            requestApi()
            setUpView()
        } else {
            if videoObj == nil{
                HUD.flash(.label("no video object"), delay:1)
                return
            }
            setUpView()
        }
    }
    func setUpView(){
        if let favorites = Global.shared.getFavoriteChannel() {
            for x in 0..<favorites.count {
                
                if videoObj.channelId == favorites[x]["id"] {
                    isFollow = true
                    index = x
                }
            }
            
        }
        Global.shared.addIdVideoWatched(id: id)
        
        setupPlayer()
        getStreamingLink()
    }
    
    
    func setupPlayer(){
        
        controller = BMPlayerCustomControlView()
        
        player = BMPlayer(customControlView: controller)
        view.addSubview(player)
        
        controller?.chooseDefitionView.isHidden = false
        
        player.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        controller?.delega = self
        player.delegate = self
        
        player.backBlock = { [unowned self] (isFullScreen) in
            if isFullScreen {
                return
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    func getStreamingLink(){
        var videoId = ""
        
        if id == "" {
            videoId = videoObj.videoId
        } else {
            videoId = id
        }
        
        HUD.show(.labeledProgress(title: "Loading...".localized(), subtitle: ""))
        
        XCDYouTubeClient.default().getVideoWithIdentifier(videoId) {  [weak self] (video: XCDYouTubeVideo?, error: Error?) in
            
            guard let strongSelf = self else { return }
            
            if let err = error {
                HUD.flash(.label(err.localizedDescription), delay: 1)
                return
            }
            
            guard let streamURLs = video?.streamURLs else {
                HUD.flash(.label("no url found"), delay: 1)
                return
            }
            
            var isHaveUrl = false
            var allRes = [(res:String, link:URL)]()
            
            if let hdURL = streamURLs[VideoQuality.hd720]  {
                allRes.append(("720p",hdURL))
                isHaveUrl = true
            }
            
            if let mediumURL = streamURLs[VideoQuality.medium360]  {
                allRes.append(("360p",mediumURL))
                isHaveUrl = true
            }
            
            if let small = streamURLs[VideoQuality.small240]  {
                allRes.append(("240p",small))
                isHaveUrl = true
            }
            
            if isHaveUrl {
                
                HUD.hide(animated: true)
                strongSelf.updatePlayer(configObj: allRes)
                
            } else{
                HUD.flash(.label("no url suitable"), delay: 1)
            }
        }
        
    }
    
    func updatePlayer(configObj:[(res:String, link:URL)]){
        
        
        var listDefinition = [BMPlayerResourceDefinition]()
        
        for obj in configObj {
            
            let small = BMPlayerResourceDefinition(url: obj.link,
                                                   definition: obj.res)
            listDefinition.append(small)
            
        }
        
        let asset = BMPlayerResource(name: "",
                                     definitions: listDefinition)
        
        player.setVideo(resource: asset)
        
        self.view.layoutIfNeeded()
        
    }
    
    func requestApi(){
        
        let url = "https://www.googleapis.com/youtube/v3/videos"
        
        let params: Parameters = ["part": "snippet,contentDetails",
                                  "id": id,
                                  "maxResults": 1,
                                  "type":"video",
                                  "key": API_KEY,]
        
        Alamofire
            .request(url, method: .get, parameters: params)
            .responseObject {[weak self] (response: DataResponse<ResponseVideo>) in
                
                guard let strongSelf = self else { return }
                
                
                if let error = response.error {
                    print(error)
                }
                
                guard let res = response.result.value else {
                    print("no value")
                    return
                }
                
                if let video = res.items {
                    strongSelf.videoObj = video[0]
                }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.isStatusBarHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.isStatusBarHidden = false
    }
    
}

extension VideoPlayerVC: BMPlayerCustomControlViewDelegate {
    
    func didTapMoreBtn() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let action = UIAlertAction(title: "Follow This Channel".localized(), style: .default) { (_) in
            
            Global.shared.addFavoriteChannel(dict: ["title":  self.videoObj.channelTitle,
                                                    "id": self.videoObj.channelId,
                                                    "thumb": self.videoObj.thumbnails])
            self.isFollow = true
        }
        
        let unfollow = UIAlertAction(title: "Unfollow".localized(), style: .default) {[unowned self] (_) in
            
            Global.shared.deleteFavoriteChannel(index: self.index)
            self.isFollow = false
        }
        
        let cancel = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
        
        if isFollow {
            alertController.addAction(unfollow)
        } else {
            alertController.addAction(action)
        }
        
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
}

extension VideoPlayerVC: BMPlayerDelegate {
    
    func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
        
    }
    
    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
        
    }
    
    func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
        
    }
    
    func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
        
    }
    
    func bmPlayer(player: BMPlayer, playerOrientChanged isFullscreen: Bool) {
        
    }
}








