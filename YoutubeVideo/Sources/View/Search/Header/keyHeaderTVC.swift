//
//  keyHeaderTVC.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/17/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit

class keyHeaderTVC: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    func configure(){
        
        title.text = "Hot Keyword".localized()
    }

}
