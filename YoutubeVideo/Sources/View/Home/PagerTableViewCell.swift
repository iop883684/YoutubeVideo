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

protocol PagerTableViewCellDelegate: NSObjectProtocol {
    
    func toDetail(_ video: Video)
}

class PagerTableViewCell: UITableViewCell, FSPagerViewDataSource, FSPagerViewDelegate {

    @IBOutlet weak var pagerView: FSPagerView!
    
    weak var delegate: PagerTableViewCellDelegate?
    
    private var videos = [Video]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")

        pagerView.isInfinite = true
        pagerView.automaticSlidingInterval = 5.0

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
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        
        delegate?.toDetail(videos[index])
    }
    
}
