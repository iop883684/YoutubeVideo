//
//  HistoryTableViewCell.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/18/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var thumb: UIImageView!
    
    func configure(_ name: String,_ img: UIImage ){
        
        title.text = name
        
        thumb.image = img

        thumb.image = thumb.image!.withRenderingMode(.alwaysTemplate)
        thumb.tintColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1)
    }
}
