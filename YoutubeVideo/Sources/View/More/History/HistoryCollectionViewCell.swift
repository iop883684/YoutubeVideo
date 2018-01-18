//
//  HistoryCollectionViewCell.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/18/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit

class HistoryCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var thumb: UIImageView!
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
    
    func configure(title: String, thumb: String){
        
        let url = URL(string: thumb)
        
        self.thumb.kf.setImage(with: url)
        
        self.title.text = title
        
        roundedView.layer.cornerRadius = 12
    }

}
