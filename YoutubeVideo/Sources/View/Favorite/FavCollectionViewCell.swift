//
//  FavCollectionViewCell.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/11/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit
import Kingfisher

class FavCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var thumb: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.thumb.layer.cornerRadius = (self.frame.height - 30) / 2
    }
    
    func configure(title: String, thumb: String){
        
        let url = URL(string: thumb)
        
        self.thumb.kf.setImage(with: url,
                               options: [.transition(ImageTransition.fade(0.5))])
        
        self.title.text = title
        
        

    }
    
}
