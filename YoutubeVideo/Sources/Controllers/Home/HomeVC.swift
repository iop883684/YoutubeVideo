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

private let homeTableCellId = "homeTableCell"

class HomeVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!

    private var data = [(title:String, obj:[PlayList])]()
    private var listPlaylist = [(title:String, channelId:String)]()
    private var playlistId: String!
    
    var playlistTitle: String!
    
    var channelTitle:String!
    var channelId: String!
    
    var isChannel: Bool!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(red: 36/255, green: 38/255, blue: 41/255, alpha: 1)

        self.configureTableView()
        
        listPlaylist = [
            ("FAP TV","UC0jDoh3tVXCaqJ6oTve8ebA"),
            ("Lets Build That App","UCuP2vJ6kRutQBfRmdcI92mA"),
            ("10IFsOfficialSubTeam","UC_R1lYegdBvvo8zLzqzz9sQ")
        ]
        
        for obj in listPlaylist{
            getListVideo(obj.channelId, obj.title)
        }
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
        backItem.tintColor = UIColor.white
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










