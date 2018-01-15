//
//  FavTableViewCell.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/11/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

private let favCellId = "favCollectionCell"

protocol FavTableViewCellDelegate: NSObjectProtocol{
    
    func toDetailPlayList( id: String, title: String)
}

class FavTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets

    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Variables
    weak var delegate : FavTableViewCellDelegate?
    var id = ""
    
    var data: [[String: String]] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let favorites = Global.shared.getFavoriteChannel() else {
            return
        }
        
        data = favorites
    }
    
    func configure(title: String, id: String){
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.registerNib(FavCollectionViewCell.self, favCellId)
    }
    

}

//MARK: - Collection Datasource

extension FavTableViewCell: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = data[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: favCellId, for: indexPath) as! FavCollectionViewCell
        
        cell.configure(title: item["title"]!, thumb: item["thumb"]!)
        
        return cell
    }
}

//MARK: - Collection Delegate

extension FavTableViewCell: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: (UIScreen.main.bounds.width - 20 *  4) / 3, height:  (UIScreen.main.bounds.width - 20 *  4) / 3)
    }

}










