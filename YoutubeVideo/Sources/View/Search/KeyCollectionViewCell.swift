//
//  KeyCollectionViewCell.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/15/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit
import TagListView
import FirebaseFirestore

class KeyCollectionViewCell: UICollectionViewCell,TagListViewDelegate {

    @IBOutlet weak var tagListView: TagListView!
    
    override func awakeFromNib() {
        let db = Firestore.firestore()
        
        db.collection("trending").document("vn").getDocument() {[weak self] (document, error) in
            
            guard let strongSelf = self else { return }
            
            if error != nil {
                print("error")
                return
            }
            guard let doc = document?.data()["keyword"] as? [String] else { return }
            
            strongSelf.setUpTagList(doc)
        }
    }
    
    func setUpTagList(_ list: [String]){
        tagListView.addTags(list)
        tagListView.borderWidth = 0;
        tagListView.clipsToBounds = true
        tagListView.textFont = UIFont.systemFont(ofSize: 15)
        tagListView.alignment = .center
    }

}
