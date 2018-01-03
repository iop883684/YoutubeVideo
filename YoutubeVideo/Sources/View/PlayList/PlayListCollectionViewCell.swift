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
    
    
    func configure(_ item: Any){
        
        if let item = item as? Video{
            
            let url = URL(string: item.thumbnails)
            
            thumb.kf.setImage(with: url)
            
            title.text = item.title
        }
    }
}
