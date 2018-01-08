//
//  VideoPlayerVC.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/8/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit
import BMPlayer

class VideoPlayerVC: UIViewController {
    
    @IBOutlet weak var player: BMCustomPlayer!

    var videoTitle: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        
        BMPlayerConf.enableChooseDefinition = true
        
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
    
}
