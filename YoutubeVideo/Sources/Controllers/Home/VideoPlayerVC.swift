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
    
    @IBOutlet weak var player: BMCustomPlayer!
    @IBOutlet weak var moreBtn: UIButton!

    var videoTitle: String!
    
    var isFollow = false
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for x in 0..<Global.shared.getFavoriteChannel().count {
            
            if Global.shared.idChannel == Global.shared.getFavoriteChannel()[x]["id"] {
                isFollow = true
                index = x
            }
        }
        
        let _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)

        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        
        BMPlayerConf.enableChooseDefinition = true
        BMPlayerConf.enableBrightnessGestures = false
        
        player.backBlock = { [unowned self] (isFullScreen) in
            if isFullScreen == true {
                return
            }
            let _ = self.navigationController?.popViewController(animated: true)
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

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }

    @IBAction func btnPressed(_ sender: UIButton){
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let action = UIAlertAction(title: "Follow This Channel", style: .default) { (_) in
            
            Global.shared.addFavoriteChannel(dict: ["title": Global.shared.titleChannel,
                                                    "id": Global.shared.idChannel])
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
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func update(){
        
        if UIApplication.shared.isStatusBarHidden == true {
            UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveEaseIn, animations: {
                
                self.moreBtn.alpha = 0
            }, completion: nil)
        }else {
            moreBtn.alpha = 1
        }
    }
    
    

}











