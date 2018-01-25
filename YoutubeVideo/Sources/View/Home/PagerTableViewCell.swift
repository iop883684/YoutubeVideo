//
//  PagerTableViewCell.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/24/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit
import FSPagerView
import Kingfisher

class PagerTableViewCell: UITableViewCell, FSPagerViewDataSource, FSPagerViewDelegate {

    @IBOutlet weak var pagerView: FSPagerView!
    
    private var videos = [Video]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
//        pagerView.transformer = FSPagerViewTransformer(type: .crossFading)
        pagerView.isInfinite = true
        pagerView.automaticSlidingInterval = 5.0
//        let transform = CGAffineTransform(scaleX: 0.8, y: 0.95)
//        pagerView.itemSize = pagerView.frame.size.applying(transform)
    }
    
    func configure(_ banner: [Video]){
        
        videos = banner
        pagerView.reloadData()
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return videos.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)

        let url = URL(string: videos[index].thumbHigh ?? videos[index].thumbnails)
        
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.layer.masksToBounds = true
        cell.imageView?.kf.setImage(with: url,
                                    options: [.transition(ImageTransition.fade(0.5))])
        
        cell.textLabel?.text = videos[index].title
        
        return cell
    }
    
}
