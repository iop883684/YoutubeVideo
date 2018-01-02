//
//  FeatureTableCell.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 12/25/17.
//  Copyright © 2017 Lac Tuan. All rights reserved.
//

import UIKit

private let homeCollectionCellId = "homeCollectionCell"

class HomeTableCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lbTitle: UILabel!
    
    //MARK: - Variables
    
    var data: [PlayList] = []
    
    override func awakeFromNib() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.registerNib(HomeCollectionCell.self, homeCollectionCellId)
        collectionView.backgroundColor = UIColor(red: 21/255, green: 21/255, blue: 21/255, alpha: 1)
        contentView.backgroundColor =  UIColor(red: 18/255, green: 21/255, blue: 24/255, alpha: 1)
    }
    
    func configure(_ item: [PlayList], _ title: String){
        
        self.data = item
        lbTitle.text = title
        
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
    
    }
}










