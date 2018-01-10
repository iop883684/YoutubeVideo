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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }

    func configure(_ item: Any){
        
        if let item = item as? Video{
            
            let url = URL(string: item.thumbnails)
            
            thumb.kf.setImage(with: url)
            
            title.text = item.title
            
            thumb.layer.cornerRadius = 12
            self.layer.cornerRadius = 12
            self.layer.shadowRadius = 6
            self.layer.shadowOpacity = 0.5
            self.layer.shadowOffset = CGSize(width: 2,height: 5)
            self.layer.masksToBounds = false
        }
    }
}
