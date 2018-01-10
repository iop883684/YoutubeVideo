//
//  HomeCollectionCell.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 12/27/17.
//  Copyright © 2017 Lac Tuan. All rights reserved.
//

import UIKit
import Kingfisher

class HomeCollectionCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var thumb: UIImageView!
    
    func configure(_ item: Any){
        
        if let item = item as? PlayList{
            
            title.text = item.title
            
            let url = URL(string: item.thumbnails)
            
            thumb.kf.setImage(with: url)
            
            //thumb.layer.cornerRadius = 12
            self.layer.cornerRadius = 12
        }
    }

}
