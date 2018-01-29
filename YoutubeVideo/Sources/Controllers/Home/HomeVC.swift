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
import Localize_Swift
import SwiftRater

private let homeTableCellId = "homeTableCell"
private let pagerCellId = "pagerCell"

class HomeVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    private var data = [(title:String, obj:[Video])]()
    private var bannerVideo = [Video]()

    private var isLoading = false
    
    private var refreshControl = UIRefreshControl()
    private var db: Firestore!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Popular".localized()
        
        configureTableView()
        
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        indicator.color = UIColor.gray
        indicator.startAnimating()

        db = Firestore.firestore()
        
        getListChannel()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setText),
                                               name: NSNotification.Name(LCLLanguageChangeNotification),
                                               object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        SwiftRater.check()
    }
    
    
    @objc func setText(){
        
        self.title = "Popular".localized()
        refreshAction()
        
    }

    
    @objc func refreshAction() {
        
        data.removeAll()
        bannerVideo.removeAll()
        tableView.reloadData()
        getListChannel()
    }

    func getListChannel(){
        

        db.collection("playlist").document(regionCode!).getDocument {[weak self] (snapshot, error) in
            
            guard let strongSelf = self else { return }
            
            strongSelf.indicator.stopAnimating()
            
            if strongSelf.refreshControl.isRefreshing{
                strongSelf.refreshControl.endRefreshing()
            }
            
            if error != nil {
                print("error:", error?.localizedDescription ?? "")
                return
            }
            
            guard let snapshot = snapshot?.data()!["channelList"] as? [[String: Any]] else { return }
            
            for snap in snapshot {
                
                if let title = snap["name"] as? String,
                    let id = snap["upload_id"] as? String {
                    strongSelf.getListVideo(id, title)
                }
                
            }
 
            
        }
        
    }
    
    func configureTableView(){
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.allowsSelection = false
        
        tableView.registerNib(PagerTableViewCell.self, pagerCellId)
        tableView.registerNib(HomeTableCell.self, homeTableCellId)
        tableView.reloadData()
    }
    
    //MARK: - Call API
    
    func getListVideo(_ uploadId: String, _ title:String){
        
        let url = "https://www.googleapis.com/youtube/v3/playlistItems"
        
        let params:Parameters = [
            "part":"snippet",
//            "type":"video",
            "key":API_KEY,
            "maxResults":10,
            "playlistId":uploadId]

        print(url)
        print(params)
        
        Alamofire
            .request(url, method: .get, parameters: params)
            .responseArray(keyPath: "items") { [weak self] (response: DataResponse<[Video]>) in
                
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
                strongSelf.bannerVideo.append(videos[0])
                strongSelf.tableView.reloadData()
                
        }
    }
    
    //
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = UIColor.black
        navigationItem.backBarButtonItem = backItem
        
        if let vc = segue.destination as? DetailPlayListVC, let obj = sender as? (id:String, title:String) {
            
            vc.vcTitle = obj.title
            vc.itemId = obj.id
            
        } else if let vc = segue.destination as? VideoPlayerVC{
            
            vc.videoObj = sender as! Video
            
        }
        
        
    }
    
    deinit {
         NotificationCenter.default.removeObserver(self)
    }
    
}

//MARK: - TableView Datasource

extension HomeVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: pagerCellId, for: indexPath) as! PagerTableViewCell
            cell.configure(bannerVideo)
            cell.delegate = self
            return cell
        }
        
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
        
        if indexPath.section == 0{
            return UIScreen.main.bounds.size.width/16*9
        }
        
        return 240
    }


}

//MARK: - HomeTableCell Delegate

extension HomeVC: HomeTableCellDelegate{
    
    func toListVideo(_ itemId: String, _ title: String) {

        performSegue(withIdentifier: "sgPlayList", sender: (id:itemId, title:title))
        
    }
    
    func openVideo(video: Video) {
        
        if video.videoId.contains("PL"){
            performSegue(withIdentifier: "sgPlayList", sender: (id:video.videoId, title:video.title))
        } else{
            performSegue(withIdentifier: "sgShowPlayerHome", sender: video)
        }
        
    }
    
}

extension HomeVC: PagerTableViewCellDelegate {
    
    func toDetail(_ video: Video) {
        
        if video.videoId.contains("PL"){
            performSegue(withIdentifier: "sgPlayList", sender: (id:video.videoId, title:video.title))
        } else{
            performSegue(withIdentifier: "sgShowPlayerHome", sender: video)
        }
    }
}









