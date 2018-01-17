//
//  SuggestionTableCell.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/16/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit

protocol SuggestionTableCellDelegate: NSObjectProtocol {
    
    func tapDeleteBtn(_ text: String)
}

class SuggestionTableCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    weak var delegate: SuggestionTableCellDelegate?
    
    func configure(_ string: String){
        
        title.text = string
    }
    
    @IBAction func btnDelete(_ sender: UIButton){
    
        delegate?.tapDeleteBtn(title.text!)
    }
    
}
