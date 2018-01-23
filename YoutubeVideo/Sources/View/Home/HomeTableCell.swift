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
    
    func toDetailPlayList(_ playlistId: String, _ playlistTitle: String)
    
    func toDetailChannel(_ channelId: String, _ channelTitle:String)
    
}

class HomeTableCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var title: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
    
    //MARK: - Variables
    
    weak var delegate: HomeTableCellDelegate?
    
    var data: [PlayList] = []
    
    var channelId: String!
    var channelTitle: String!
    
    override func awakeFromNib() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.registerNib(HomeCollectionCell.self, homeCollectionCellId)
        
    }
    
    @IBAction func moreBtnPressed(_ sender: UIButton) {
        
        delegate?.toDetailChannel(channelId, channelTitle)
    }
    
    @IBAction func titlePressed(_ sender: UIButton){
        
        delegate?.toDetailChannel(channelId, channelTitle)
    }
    
    func configure(_ item: [PlayList], _ title: String, _ channelId: String, _ channelTitle: String){
        
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
    
        let item = data[indexPath.row]
        delegate?.toDetailPlayList(item.id , item.title)
    }
}










