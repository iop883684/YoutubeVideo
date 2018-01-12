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
    @IBOutlet weak var title: UILabel!
    
    //MARK: - Variables
    weak var delegate : FavTableViewCellDelegate?
    var id = ""
    
    var isGetVideo = false
    
    private var data = [PlayList]()
    
    func configure(title: String, id: String){
        
        self.title.text = title
        self.id = id
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.registerNib(FavCollectionViewCell.self, favCellId)
        collectionView.reloadData()
        
        if !isGetVideo{
            getListVideo(id)
            isGetVideo = true
        }
    }
    
    //MARK: - Call API
    
    func getListVideo(_ channelId: String){
        
        let url = "https://www.googleapis.com/youtube/v3/playlists"
        
        
        let params:Parameters = [
            "part":"snippet,contentDetails",
            "type":"video",
            "key":API_KEY,
            "maxResults":10,
            "channelId":channelId]
        
        
        Alamofire
            .request(url, method: .get, parameters: params)
            .responseArray(keyPath: "items") { [weak self] (response: DataResponse<[PlayList]>) in
                
                print(url)
                guard let strongSelf = self else {return}
                
                if let error = response.result.error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let videos = response.result.value else {
                    print("Empty")
                    return
                }
                
                strongSelf.data.append(contentsOf: videos)
                strongSelf.collectionView.reloadData()
        }
    }
}

//MARK: - Collection Datasource

extension FavTableViewCell: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: favCellId, for: indexPath) as! FavCollectionViewCell
        
        cell.configure(data[indexPath.row])
        
        return cell
    }
}

//MARK: - Collection Delegate

extension FavTableViewCell: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 320, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = data[indexPath.row]
        delegate?.toDetailPlayList(id: item.id , title: item.title)
    }

}










