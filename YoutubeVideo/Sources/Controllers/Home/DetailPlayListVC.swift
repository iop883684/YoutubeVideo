//
//  DetailPlayListVC.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/3/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

private let playListCellId = "playListCell"

class DetailPlayListVC: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Variables
    
    var channelId = ""
    var playlistId = ""
    
    var data: [Video] = []
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
   
        requestApi()
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(red: 36/255, green: 38/255, blue: 41/255, alpha: 1)

        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.registerNib(PlayListCollectionViewCell.self, playListCellId)
        
        collectionView.reloadData()
    }
    
    //MARK: - Call API
    
    func requestApi(){
        
        let url = "https://www.googleapis.com/youtube/v3/playlistItems"
        
        let params: Parameters = ["part": "snippet,contentDetails",
                                  "maxResults": 10,
                                  "key": API_KEY,
                                  "playlistId": playlistId]

        Alamofire
            .request(url, method: .get, parameters: params)
            .responseArray(keyPath: "items") {[weak self] (response: DataResponse<[Video]>) in
                
                guard let strongSelf = self else { return }
                
                if let error = response.error {
                    print(error)
                }
                
                guard let video = response.result.value else {
                    print("112312312")
                    return
                }

                strongSelf.data = video
                strongSelf.collectionView.reloadData()
                
        }
        
    }


}

//MARK: - tableview datasource

extension DetailPlayListVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: playListCellId , for: indexPath) as! PlayListCollectionViewCell
        
        cell.configure(data[indexPath.row])
        
        return cell
    }
}

//MARK: - TableView Delegate

extension DetailPlayListVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 380, height: 210)
    }
}









