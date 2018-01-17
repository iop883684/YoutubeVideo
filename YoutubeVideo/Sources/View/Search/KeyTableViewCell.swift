//
//  KeyTableViewCell.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/16/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit
import FirebaseFirestore
import TagListView

protocol KeyTableViewCellDelegate: NSObjectProtocol {
   
    func reloadSection()
    func clickBtn(_ btnTitle: String)
}

class KeyTableViewCell: UITableViewCell, TagListViewDelegate {

    @IBOutlet weak var tagListView: TagListView!
    
    weak var delegate: KeyTableViewCellDelegate?
    
    override func awakeFromNib() {
        
        tagListView.delegate = self
        
        guard let regionCode = Locale.current.regionCode else { return }
        
        let region = regionCode.lowercased()
        
        let db = Firestore.firestore()
        
        db.collection("trending").document(region).getDocument() {[weak self] (document, error) in
            
            guard let strongSelf = self else { return }
            
            if error != nil {
                print("error")
                return
            }
            guard let doc = document?.data()["keyword"] as? [String] else { return }
            
            strongSelf.setUpTagList(doc)
            
            strongSelf.delegate?.reloadSection()
        }
    }
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        
        delegate?.clickBtn(title)
    }
    
    func setUpTagList(_ list: [String]){
        tagListView.addTags(list)
        tagListView.borderWidth = 0;
        tagListView.clipsToBounds = true
        tagListView.textFont = UIFont.systemFont(ofSize: 13)
        tagListView.alignment = .center
    }
}








