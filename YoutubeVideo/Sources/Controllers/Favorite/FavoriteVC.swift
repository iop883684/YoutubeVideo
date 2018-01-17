//
//  FavoriteVC.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/11/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit

private let favCellId = "favCollectionCell"

class FavoriteVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var label: UILabel!
    
    //MARK: - Variables
    
    var data: [[String: String]] = []
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let favorites = Global.shared.getFavoriteChannel() else {
            return
        }
        
        if data.count != favorites.count {
            data = favorites
            collectionView.reloadData()
        }
    }
    
    //
    
    func setUpTableView(){
        
        collectionView.backgroundView = label
        collectionView.backgroundView?.isHidden = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.registerNib(FavCollectionViewCell.self, favCellId)
        
    }
}

//MARK: - Collection Datasource

extension FavoriteVC: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if data.count != 0 {
            collectionView.backgroundView?.isHidden = true
            return data.count
        } else {
            collectionView.backgroundView?.isHidden = false
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = data[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: favCellId, for: indexPath) as! FavCollectionViewCell
        
        cell.configure(title: item["title"]!, thumb: item["thumb"]!)
        
        return cell
    }
}

//MARK: - Collection Delegate

extension FavoriteVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.width
        
        return CGSize.init(width: (width - 10 * 4 ) / 3, height: (width - 10 * 4) / 3)
    }
    
}












