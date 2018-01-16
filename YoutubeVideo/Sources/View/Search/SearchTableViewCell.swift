//
//  SearchTableViewCell.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/16/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var roundedView: UIView!
    
    var isSetShadow = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        roundedView.layer.shadowRadius = 2.5
        roundedView.layer.shadowOpacity = 0.7
        roundedView.layer.shadowOffset = CGSize.zero
        roundedView.layer.cornerRadius = 12
        roundedView.layer.masksToBounds = false
        thumb.layer.masksToBounds = true
    }
    
    func configure(_ item: Any){
        
        if let item = item as? Video {
            
            let url = URL(string: item.thumbnails)
            
            thumb.kf.setImage(with: url)
            
            title.text = item.title

            
        }
    }

    
}
