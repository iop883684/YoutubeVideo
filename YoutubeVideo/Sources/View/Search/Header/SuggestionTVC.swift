//
//  SuggestionTVC.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/17/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit

protocol SuggestionTVCDelegate: NSObjectProtocol {
    
    func tapDeleteBtn()
}

class SuggestionTVC: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!

    weak var delegate: SuggestionTVCDelegate?
    
    
    @IBAction func deleteBtn(_ sender: UIButton){
        
        delegate?.tapDeleteBtn()
    }
    
    func configure() {
        title.text = "History".localized()
        deleteBtn.setTitle("Delete all".localized(), for: .normal)
    }
}
