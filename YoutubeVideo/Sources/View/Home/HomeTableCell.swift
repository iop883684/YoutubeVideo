//
//  FeatureTableCell.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 12/25/17.
//  Copyright © 2017 Lac Tuan. All rights reserved.
//

import UIKit

let homeTableCellId = "homeTableCell"

class HomeTableCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var title: UILabel!
    
    //MARK: - Variables
    
    var data: [PlayList] = []
    
    func configure(_ item: Any, _ title: String){
        
        if let item = item as? [PlayList] {
            self.data = item
        }
        
        self.title.text = title
        
        configCollectionView()
    }
    
    func configCollectionView(){
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.registerNib(HomeCollectionCell.self, homeCollectionCellId)
        collectionView.backgroundColor = UIColor(red: 21/255, green: 21/255, blue: 21/255, alpha: 1)
        
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
}










