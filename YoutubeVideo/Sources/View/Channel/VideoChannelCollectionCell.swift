//
//  VideoChannelCollectionCell.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/4/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit

class VideoChannelCollectionCell: UICollectionViewCell {

    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    func configure(_ title: String, _ url: String){
        
        let url = URL(string: url)
        
        thumb.kf.setImage(with: url)
        
        self.title.text = title
    }

}
