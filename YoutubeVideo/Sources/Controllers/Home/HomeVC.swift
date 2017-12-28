//
//  HomeVC.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 12/25/17.
//  Copyright © 2017 Lac Tuan. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import Alamofire
import PKHUD

private let url1 = "https://www.googleapis.com/youtube/v3/playlists?maxResults=10&channelId=UC0jDoh3tVXCaqJ6oTve8ebA&part=snippet%2CcontentDetails%20&key=\(API_KEY)"

private let url2 = "https://www.googleapis.com/youtube/v3/playlists?maxResults=10&channelId=UCuP2vJ6kRutQBfRmdcI92mA&part=snippet%2CcontentDetails%20&key=\(API_KEY)"

private let url3 = "https://www.googleapis.com/youtube/v3/playlists?maxResults=10&channelId=UC_R1lYegdBvvo8zLzqzz9sQ&part=snippet%2CcontentDetails%20&key=\(API_KEY)"


class HomeVC: BaseVC {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    
    var data: [Any] = []
    
    var playList: [PlayList] = []
    
    var otherPlayList: [PlayList] = []
    
    var listTitle: [String] = []
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTitle = ["FAP TV", "Lets Build That App", "10IFsOfficialSubTeam"]
        
        requestApi(url1) {
            self.requestApi(url2, completion: {
                self.requestApi(url3, completion: {
                    self.configureTableView()
                })
            })
        }
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(red: 36/255, green: 38/255, blue: 41/255, alpha: 1)

        
    }
    
    func configureTableView(){
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.allowsSelection = false
        tableView.backgroundColor = UIColor(red: 21/255, green: 21/255, blue: 21/255, alpha: 1)
        
        tableView.registerNib(HomeTableCell.self, homeTableCellId)
        tableView.reloadData()
    }
    
    //MARK: - Call API
    
    func requestApi(_ url: String, completion: (() -> ())?){
        
        HUD.show(.labeledProgress(title: "Loading", subtitle: ""))
        
        Alamofire
            .request(url, method: .get)
            .responseArray(keyPath: "items") { [weak self] (response: DataResponse<[PlayList]>) in
                
                guard let strongSelf = self else {
                    return
                }
                
                if response.result.error != nil {
                    print("Error")
                }
                
                guard let playList = response.result.value else {
                    return print("Empty")
                }
                
                if url == url1 {
                    strongSelf.playList = playList
                }
                
                if url == url2 {
                    strongSelf.otherPlayList = playList
                }
                
                HUD.hide(animated: true)
                
                strongSelf.data = playList
                
                completion?()
        }
    }
}

//MARK: - TableView Datasource

extension HomeVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: homeTableCellId, for: indexPath) as! HomeTableCell
            
            cell.contentView.backgroundColor =  UIColor(red: 18/255, green: 21/255, blue: 24/255, alpha: 1)
            
            cell.configure(playList, listTitle[indexPath.row])
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: homeTableCellId, for: indexPath) as! HomeTableCell
            
            cell.contentView.backgroundColor =  UIColor(red: 18/255, green: 21/255, blue: 24/255, alpha: 1)
            
            cell.configure(otherPlayList, listTitle[indexPath.row])
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: homeTableCellId, for: indexPath) as! HomeTableCell
            
            cell.contentView.backgroundColor =  UIColor(red: 18/255, green: 21/255, blue: 24/255, alpha: 1)
            
            cell.configure(data, listTitle[indexPath.row])
            
            return cell
        default:
            return UITableViewCell()
        }
    }
}

//MARK: - Table View Delegate

extension HomeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
}
