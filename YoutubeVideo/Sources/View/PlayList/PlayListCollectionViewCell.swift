//
//  PlayListCollectionViewCell.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/3/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit

class PlayListCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var roundedView: UIView!
    
    var isSetShadow = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isSetShadow{
            return
        }
        
        isSetShadow = true
        
        self.layer.shadowRadius = 2.5
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize.zero
        self.layer.masksToBounds = false
        
    }

    func configure(_ item: Any){
        
        if let item = item as? Video{
            
            let url = URL(string: item.thumbnails)
            
            thumb.kf.setImage(with: url)
            
            title.text = item.title
            roundedView.layer.cornerRadius = 12
            self.layer.cornerRadius = 12
            
        }
    }
}
