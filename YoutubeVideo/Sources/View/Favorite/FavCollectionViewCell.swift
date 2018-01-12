//
//  FavCollectionViewCell.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/11/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit

class FavCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var thumb: UIImageView!
    
    func configure(_ item: Any){
        
        if let item = item as? PlayList{
            
            let url = URL(string: item.thumbnails)
            
            thumb.kf.setImage(with: url)
            
            title.text = item.title
            
            self.layer.cornerRadius = 12
        }
    }

}
