//
//  VideoPlayerVC.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/8/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit
import BMPlayer

class VideoPlayerVC: UIViewController{

    @IBOutlet weak var moreBtn: UIButton!
    
    private var videoTitle: String!
    private var player: BMPlayer!
    
    private var isFollow = false
    private var controller: BMPlayerCustomControlView? = nil
    private var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let favorites = Global.shared.getFavoriteChannel() {
            for x in 0..<favorites.count {
                
                if Global.shared.idChannel == favorites[x]["id"] {
                    isFollow = true
                    index = x
                }
            }
            
        }
        
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
                let _ = self.navigationController?.popViewController(animated: true)
            }
        }
        
        var listDefinition = [BMPlayerResourceDefinition]()
        
        if UrlVideo.small != nil{
            let small = BMPlayerResourceDefinition(url: UrlVideo.small,
                                                   definition: "240p")
            listDefinition.append(small)
        }
        
        
        if UrlVideo.medium != nil{
            let medium = BMPlayerResourceDefinition(url: UrlVideo.medium,
                                                    definition: "360p")
            listDefinition.append(medium)
        }
        
        
        if UrlVideo.hd != nil {
            let hd = BMPlayerResourceDefinition(url: UrlVideo.hd,
                                                definition: "720p")
            listDefinition.append(hd)
            
        }
        
        let asset = BMPlayerResource(name: "",
                                     definitions: listDefinition,
                                     cover: UrlVideo.medium)
        
        player.setVideo(resource: asset)
        
        self.view.layoutIfNeeded()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        UIApplication.shared.isStatusBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
        UIApplication.shared.isStatusBarHidden = false
    }
    
}

extension VideoPlayerVC: BMPlayerCustomControlViewDelegate {
    func didTapMoreBtn() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let action = UIAlertAction(title: "Follow This Channel", style: .default) { (_) in
            
            Global.shared.addFavoriteChannel(dict: ["title": Global.shared.titleChannel,
                                                    "id": Global.shared.idChannel,
                                                    "thumb": Global.shared.thumbChannel])
        }
        
        let unfollow = UIAlertAction(title: "Unfollow", style: .default) {[unowned self] (_) in
            
            Global.shared.deleteFavoriteChannel(index: self.index)
        }
        
        let cancel = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
        
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










