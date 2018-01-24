//
//  FSPagerViewCell.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/24/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit
import FSPagerView

class FSPagerViewCell: UITableViewCell, FSPagerViewDataSource, FSPagerViewDelegate {

    @IBOutlet weak var pagerView: FSPagerView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        pagerView.dataSource = self
        self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        
    }
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 3
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index) as! FSPagerViewCell
        
        return cell
    }
}


