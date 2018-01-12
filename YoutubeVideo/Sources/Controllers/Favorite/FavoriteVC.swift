//
//  FavoriteVC.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/11/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit

private let favCellId = "favCell"

class FavoriteVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var label: UILabel!
    
    private var refreshControl = UIRefreshControl()
    
    var isChannel: Bool!
    
    var id = ""
    var channelTitle = ""
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
    }
    
    //
    
    func setUpTableView(){
        
        tableView.backgroundView = label
        tableView.backgroundView?.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsSelection = false
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        tableView.registerNib(FavTableViewCell.self, favCellId)
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    @objc func refreshAction(){
        
        tableView.reloadData()
        
        refreshControl.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailPlayListVC {
            
            isChannel = false
            vc.isChannel = isChannel
            vc.id = self.id
            vc.vcTitle = self.channelTitle
        }
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = UIColor.black
        navigationItem.backBarButtonItem = backItem
    }
    
}

//MARK: - TAbleview Datasource

extension FavoriteVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let data = Global.shared.getFavoriteChannel()?.count else {
            tableView.backgroundView?.isHidden = false
            return 0
        }
        
        if data != 0 {
            tableView.backgroundView?.isHidden = true
        }
        return data
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = Global.shared.getFavoriteChannel()![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: favCellId, for: indexPath) as! FavTableViewCell
        
        cell.delegate = self
        
        cell.configure(title: item["title"]!, id: item["id"]!)
        
        return cell
    }
}

//MARK: - Tableview Delegate

extension FavoriteVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
}

//MARK: - Favorite Delegate

extension FavoriteVC: FavTableViewCellDelegate{
    
    func toDetailPlayList(id: String, title: String) {
        self.id = id
        self.channelTitle = title
        performSegue(withIdentifier: "sgToDetail", sender: nil)
    }
}











