//
//  FeatureTableCell.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 12/25/17.
//  Copyright © 2017 Lac Tuan. All rights reserved.
//

import UIKit

private let homeCollectionCellId = "homeCollectionCell"

protocol HomeTableCellDelegate: NSObjectProtocol{
    
    func toListVideo(_ itemId: String,_ title: String)
    func openVideo(video:Video)
    
}

class HomeTableCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var title: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
    
    //MARK: - Variables
    
    weak var delegate: HomeTableCellDelegate?
    
    private var data: [Video] = []
    
    private var channelId: String!
    private var channelTitle: String!
    
    override func awakeFromNib() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.registerNib(HomeCollectionCell.self, homeCollectionCellId)
        
    }
    
    @IBAction func moreBtnPressed(_ sender: UIButton) {
        
        delegate?.toListVideo(channelId, channelTitle)
    }
    
    @IBAction func titlePressed(_ sender: UIButton){
        
        delegate?.toListVideo(channelId, channelTitle)
    }
    
    func configure(_ item: [Video], _ title: String, _ channelId: String, _ channelTitle: String){
        
        self.data = item
        //lbTitle.text = title
        self.title.setTitle(title, for: .normal)
        self.channelId = channelId
        self.channelTitle = channelTitle
        
        collectionView.reloadData()
    }
    
    
}

//MARK: - Collection View DataSource

extension HomeTableCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeCollectionCellId, for: indexPath) as! HomeCollectionCell
        moreBtn.setTitle("See More".localized(), for: .normal)
        cell.configure(data[indexPath.row])
        
        return cell
    }
    
}

//MARK: - Collection View Delegate

extension HomeTableCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 320, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  
        delegate?.openVideo(video: data[indexPath.row])
    }
}










