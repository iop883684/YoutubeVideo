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
import Firebase
import FirebaseFirestore

private let homeTableCellId = "homeTableCell"

class HomeVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    private var data = [(title:String, obj:[PlayList])]()
    
    private var playlistId: String!
    
    private var playlistTitle: String!
    private var channelTitle:String!
    private var channelId: String!
    
    private var isChannel: Bool!
    private var isLoading = false
    
    private var refreshControl = UIRefreshControl()
    private var db: Firestore!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        indicator.color = UIColor.gray
        indicator.startAnimating()

        db = Firestore.firestore()
        
        getListChannel()
    }
    

    
    @objc func refreshAction() {
        
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Home".localized()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    

    func getListChannel(){
        
        db.collection("playlist").document(regionCode!).getDocument {[weak self] (snapshot, error) in
            
            guard let strongSelf = self else { return }
            
            if error != nil {
                print("error")
                return
            }
            
            guard let snapshot = snapshot?.data()!["channelList"] as? [[String: Any]] else { return }
            
            for snap in snapshot {
                
                let title = snap["name"] as! String
                let id = snap["id"] as! String
                
                strongSelf.getListVideo(id, title)
                strongSelf.tableView.reloadData()
            }
            
            strongSelf.indicator.stopAnimating()
        }
        
    }
    
    func configureTableView(){
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.allowsSelection = false
        
        tableView.registerNib(HomeTableCell.self, homeTableCellId)
        tableView.reloadData()
    }
    
    //MARK: - Call API
    
    func getListVideo(_ channelId: String, _ title:String){
        
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
                
                guard let strongSelf = self else {return}

                strongSelf.refreshControl.endRefreshing()
                
                if let error = response.result.error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let videos = response.result.value else {
                    print("Empty")
                    return
                }
                
                strongSelf.data.append((title,videos))
                strongSelf.tableView.reloadData()
                
        }
    }
    
    //
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailPlayListVC {
            
            if !isChannel {
                vc.id = self.playlistId
                
                vc.vcTitle = self.playlistTitle
                
            }else {
                vc.id = self.channelId
                vc.vcTitle = self.channelTitle
            }
            
             vc.isChannel = self.isChannel
            
        }
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = UIColor.black
        navigationItem.backBarButtonItem = backItem
    }
}

//MARK: - TableView Datasource

extension HomeVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: homeTableCellId, for: indexPath) as! HomeTableCell
        
        let obj = data[indexPath.row]
        cell.delegate = self
        cell.configure(obj.obj, obj.title, obj.obj[indexPath.row].channelId, obj.obj[indexPath.row].channelTitle)
        
        return cell

    }
}

//MARK: - Table View Delegate

extension HomeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }

}

//MARK: - HomeTableCell Delegate

extension HomeVC: HomeTableCellDelegate{
    
    func toDetailPlayList(_ playlistId: String, _ playlistTitle: String){
        
        self.playlistTitle = playlistTitle
        self.playlistId = playlistId
        self.isChannel = false
        performSegue(withIdentifier: "sgPlayList", sender: nil)
    }
    
    func toDetailChannel(_ channelId : String, _ channelTitle:String){
        
        self.channelId = channelId
        self.channelTitle = channelTitle
        self.isChannel = true
        performSegue(withIdentifier: "sgPlayList", sender: nil)
    }
    
}










