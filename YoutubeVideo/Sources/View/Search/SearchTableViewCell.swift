//
//  SearchTableViewCell.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/16/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit
import Kingfisher

class SearchTableViewCell: UITableViewCell {

    
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var roundedView: UIView!
    
     private var isSetShadow = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isSetShadow{
            return
        }
        
        isSetShadow = true
        
        roundedView.layer.shadowRadius = 2.5
        roundedView.layer.shadowOpacity = 0.7
        roundedView.layer.shadowOffset = CGSize.zero
        roundedView.layer.cornerRadius = 7
        roundedView.layer.masksToBounds = true

    }
    
    
    func configure(_ item: Any){
        
        if let item = item as? Video {
            
            let url = URL(string: item.thumbnails)
            
            thumb.kf.setImage(with: url,
                              options: [.transition(ImageTransition.fade(0.5))])
            
            title.text = item.title

            
        }
    }

    
}
