//
//  HistoryVC.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/18/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import PKHUD

private let historyCellId = "historyCell"

class HistoryVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var notiLbl: UILabel!
    
    //MARK: - Variables

    private var data = [Video]()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        notiLbl.isHidden = true
        title = "History".localized()
        notiLbl.text = "watched no video".localized()
        
        configCollection()
    }
    
    func configCollection(){
  
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.registerNib(HistoryCollectionViewCell.self, historyCellId)
        
        guard let videoWatched = Global.shared.getIdVideoWatched() else {
            return
        }
        
        for id in videoWatched{
            requestAPI(id: id)
        }
        
    }

    
    func requestAPI(id: String){
        
        let url = "https://www.googleapis.com/youtube/v3/videos"
        
        let params: Parameters = ["part": "snippet,contentDetails,statistics",
                                  "id": id,
                                  "key": API_KEY]
        
        Alamofire
            .request(url, method: .get, parameters: params)
            .responseObject {[weak self] (res: DataResponse<ResponseVideo>) in
                
                guard let strongSelf = self else { return }
                
                if let error = res.error {
                    HUD.flash(.label(error.localizedDescription), delay: 1)
                    return
                }
                
                if let video = res.result.value?.items {
                    
                    strongSelf.data.append(contentsOf: video)
                    strongSelf.collectionView.reloadData()
                    
                }
                
                if strongSelf.data.count == 0 {
                    strongSelf.notiLbl.isHidden = false
                }
                
        }
    }
    
}

//MARK: - CollectionView Datasource

extension HistoryVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if data.count > 0 {
            return data.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: historyCellId, for: indexPath) as! HistoryCollectionViewCell
        
        cell.configure(title: data[indexPath.row].title, thumb: data[indexPath.row].thumbnails)
        
        return cell
    }
}

//MARK: - CollectionView Delegate

extension HistoryVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 320, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let sb = UIStoryboard(name: Storyboard.Home.name, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "VideoPlayerVC") as! VideoPlayerVC
        vc.videoObj = data[indexPath.item]
        self.present(vc, animated: true, completion: nil)
        
    }
    
}
















