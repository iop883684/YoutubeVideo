//
//  PagerTableViewCell.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/24/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit
import FSPagerView

class PagerTableViewCell: UITableViewCell, FSPagerViewDataSource, FSPagerViewDelegate {

    @IBOutlet weak var pagerView: FSPagerView!
    
    private var thumb = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
        pagerView.isInfinite = true
        pagerView.automaticSlidingInterval = 3.0
        let transform = CGAffineTransform(scaleX: 0.8, y: 0.95)
        pagerView.itemSize = pagerView.frame.size.applying(transform)
    }
    
    func configure(_ banner: [String]){
        
        thumb = banner
        pagerView.reloadData()
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return thumb.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        let url = URL(string: thumb[index])
        
        cell.imageView?.kf.setImage(with: url)
        
        return cell
    }
    
}
