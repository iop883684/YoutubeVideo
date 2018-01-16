//
//  SuggestionTableCell.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/16/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit

class SuggestionTableCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    func configure(_ string: String){
        
        title.text = string
    }
    
}
