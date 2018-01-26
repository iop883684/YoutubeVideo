//
//  SearchVC.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/15/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import XCDYouTubeKit
import FirebaseFirestore
import Localize_Swift
import BiometricAuthentication

private let searchCellId = "searchCell"
private let keyCellId = "keyCell"
private let suggestCellId = "suggestCell"
private let keyHeaderCellId = "keyHeaderCell"
private let suggestHeaderId = "suggestHeader"

class SearchVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    lazy var searchBar = UISearchBar(frame: CGRect.zero)
    
    private var data: [Video] = []
    private var suggestionWords = [String]()
    private var historyData = [String]()
    private var hotKeyWord = [String]()
    
    private var nextPageToken = ""
    private var searchText = ""
    
    private var searchTimer: Timer?

    private var isShowHistory = true
    private var isSearching = true
    private var isHaveUrl = false
    private var isFull = false
    private var isLoading = false
    
    private var isVerifyTouchID = false
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setText),
                                               name: NSNotification.Name(LCLLanguageChangeNotification),
                                               object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.setText()
        navigationItem.titleView = searchBar
        
        searchBar.delegate = self
        searchBar.showsCancelButton = true
//        searchBar.becomeFirstResponder()
        
        setUpTableView()
        
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func setText(){
        
        self.title = "Search".localized()
    }

    func setUpTableView(){
        
        historyData = HistorySearch.shared.getSearchHistories()?.reversed() ?? []
        
        tableView.registerNib(SearchTableViewCell.self, searchCellId)
        tableView.registerNib(KeyTableViewCell.self, keyCellId)
        tableView.registerNib(SuggestionTableCell.self, suggestCellId)
        tableView.registerNib(keyHeaderTVC.self, keyHeaderCellId)
        tableView.registerNib(SuggestionTVC.self, suggestHeaderId)
        
        tableView.keyboardDismissMode = .onDrag
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.reloadData()
    }
    
    //MARK: - CaLL API
    
    func requestAPI(_ text: String){
        
        if isLoading{
            return
        }
        
        isLoading = true

        let url = "https://www.googleapis.com/youtube/v3/search"
        
        let params: Parameters = ["part": "snippet",
                                  "maxResults": 10,
                                  "q": text,
                                  "key": API_KEY,
                                  "pageToken":nextPageToken,
                                  "regionCode": Locale.current.regionCode ?? "",
                                  "type": "video"]
        
        print(params)
        
        Alamofire
            .request(url, method: .get, parameters: params)
            .responseObject {[weak self] (res: DataResponse<ResponseVideo>) in
                
                guard let strongSelf = self else { return }
                
                strongSelf.isLoading = false
                
                if let error = res.error {
                    print(error)
                }
                
                guard let res = res.result.value else {
                    print("empty")
                    return
                }
                
                print(res)
                
                if let video = res.items {
                    
                    if video.count < 10 {
                        strongSelf.isFull = true
                    }
                    
                    strongSelf.nextPageToken = res.nextPageToken ?? ""
                    strongSelf.data.append(contentsOf: video)
                    strongSelf.tableView.reloadData()
                }
        }
    }
    
    //
    
    @objc func getSuggesstionKey(){
        
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        
        let params = ["client":"firefox", "q":text]
        let url = "http://suggestqueries.google.com/complete/search"
        print("search key: \(text)")
        
        
        Alamofire
            .request(url, method: .get, parameters: params)
            .response(completionHandler: { [weak self]  (res) in
                
                guard let strongSelf = self else {return}
                
                if let data = res.data{
                    
                    let str = String(data: data, encoding: String.Encoding.isoLatin1)
                    //                    print("string:", str ?? "")
                    guard let newData = str?.data(using: String.Encoding.utf8) else {
                        return
                    }
                    
                    do {
                        
                        let obj = try JSONSerialization.jsonObject(with: newData, options: JSONSerialization.ReadingOptions.allowFragments)
                        //                        print("json", obj)
                        
                        let arr = obj as! [Any]
                        let lastArr = arr[1]
                        strongSelf.suggestionWords = lastArr as! [String]
                        strongSelf.tableView.reloadData()
                        
                    } catch{
                        
                        print("json error", error.localizedDescription)
                        
                    }
                    
                } else{
                    print("error ", res.error ?? "unknown")
                    
                }
                
            })
        
        
    }
    

    
}


//MARK: - tableView Datasource

extension SearchVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        
        if isShowHistory {
            return historyData.count
        } else {
            return !isSearching ? data.count : suggestionWords.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
            
        case 0:
            
            let header = tableView.dequeueReusableCell(withIdentifier: keyHeaderCellId) as! keyHeaderTVC
            
            header.configure()
            
            return header
            
        case 1:
            
            let header = tableView.dequeueReusableCell(withIdentifier: suggestHeaderId) as! SuggestionTVC
            
            header.configure()
            
            header.delegate = self
            return header
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: keyCellId, for: indexPath) as! KeyTableViewCell

            cell.delegate = self
            
            return cell
        }
        
        if !isSearching && !isShowHistory {

            let item = data[indexPath.row]

            let cell = tableView.dequeueReusableCell(withIdentifier: searchCellId, for: indexPath) as! SearchTableViewCell

            cell.configure(item)

            return cell
        
        } else {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: suggestCellId, for: indexPath) as! SuggestionTableCell
            
            cell.title.text = isShowHistory ? historyData[indexPath.row] : suggestionWords[indexPath.row]
            
            cell.deleteBtn.isHidden = isShowHistory ? false : true
            
            cell.delegate = self
            
            return cell
        }
    }
}

//MARK: - TableView Delegate

extension SearchVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if isShowHistory {
            
            switch section {
                
            case 0:
                return 35
        
            case 1:
                return 44
                
            default:
                return 0
            }
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if indexPath.section == 0{
            if isShowHistory {
                return UITableViewAutomaticDimension
            } else {
                return 0
            }
        }
        if isSearching {
            return 44
        }
        if isShowHistory {
            return 44
        }
        return 230
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.section == 0{
            if isShowHistory {
                return UITableViewAutomaticDimension
            } else {
                return 0
            }
        }
        if isSearching {
            return 44
        }
        if isShowHistory {
            return 44
        }
        return 230
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 1:
            if isShowHistory {
                
                searchBar.text = historyData[indexPath.row]
                searchBarSearchButtonClicked(searchBar)
            } else if isSearching {
                searchBar.text = suggestionWords[indexPath.row]
                searchBarSearchButtonClicked(searchBar)
            } else {
                
                let sb = UIStoryboard(name: Storyboard.Home.name, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "VideoPlayerVC") as! VideoPlayerVC
                vc.videoObj = data[indexPath.row]
                self.present(vc, animated: true, completion: nil)
                
            }
        default:
            break;
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            if !isFull && !isLoading && !isSearching && !isShowHistory {
                requestAPI(searchText)
            }
        }
    }
    
}


//MARK: - Search Bar Delegate

extension SearchVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        
        data.removeAll()
        requestAPI(searchBar.text!)
        searchText = searchBar.text!
        isShowHistory = false
        isSearching = false
        searchTimer?.invalidate()
        updateSearchHistory(text: searchText)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        if isVerifyTouchID == false {
            authenticationWithTouchID ()
            isVerifyTouchID = true
        }
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            isSearching = false
            isShowHistory = true
            suggestionWords.removeAll()
            tableView.reloadData()
            
        } else {
            
            if isShowHistory == false {
                return
            }
            isSearching = true
            isShowHistory = false
            data.removeAll()
            tableView.reloadData()
            
            searchTimer?.invalidate()
            searchTimer = Timer.scheduledTimer(timeInterval: 1,
                                               target: self,
                                               selector: #selector(getSuggesstionKey),
                                               userInfo: nil,
                                               repeats: true)
            searchTimer?.fire()
            
            
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        data.removeAll()
        suggestionWords.removeAll()
        tableView.reloadData()
        searchBar.resignFirstResponder()
        

    }
    
    func updateSearchHistory(text:String){
        
        if let index = historyData.index(of: text){
            
            HistorySearch.shared.deleteSearchHistories(index: historyData.count - index - 1)
            historyData.remove(at: index)
            
        }
        
        HistorySearch.shared.appendSearchHistories(value: text)
        historyData.insert(text, at: 0)
        tableView.reloadData()
        view.sendSubview(toBack: tableView)
        
    }
    
}

//MARK: - HotKeyWordCell Delegate

extension SearchVC: KeyTableViewCellDelegate {
    
    func reloadSection() {
        tableView.reloadData()
    }
    
    func clickBtn(_ btnTitle: String){
        
        searchBar.text = btnTitle
        searchBarSearchButtonClicked(searchBar)
    }
}

//MARK: - SuggestionWordCell Delegate

extension SearchVC: SuggestionTableCellDelegate {
    
    func tapDeleteBtn(_ text: String) {
        
        guard let index = historyData.index(of: text) else {
            return
        }
        
        HistorySearch.shared.deleteSearchHistories(index: historyData.count - index - 1)
        historyData.remove(at: index)
        
        let indexPath = IndexPath(row: index, section: 1)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.reloadData()
    }
}

extension SearchVC: SuggestionTVCDelegate{
    
    func tapDeleteBtn() {
        
        HistorySearch.shared.clearData()
        historyData.removeAll()
        tableView.reloadData()
    }
}

//MARK: - Touch ID Authentication


extension SearchVC {
    
    func authenticationWithTouchID() {
        
        BioMetricAuthenticator.authenticateWithBioMetrics(reason: "To access secure data", success: { [weak self] in
            
            guard let strongSelf = self else { return }
            // authentication successful
            
            strongSelf.searchBar.becomeFirstResponder()
            
            }, failure: { (error) in
                
                // do nothing on canceled
                if error == .canceledByUser || error == .canceledBySystem {
                    return
                }
                    
                    // show alternatives on fallback button clicked
                else if error == .fallback {
                    
                    // here we're entering username and password
                    
                }
                    
                    // No biometry enrolled in this device, ask user to register fingerprint or face
                else if error == .biometryNotEnrolled {
                    
                }
                    
                    // Biometry is locked out now, because there were too many failed attempts.
                    // Need to enter device passcode to unlock.
                else if error == .biometryLockedout {
                    // show passcode authentication
                }
                    
                    // show error on authentication failed
                else {
                    
                }
                BioMetricAuthenticator.authenticateWithPasscode(reason: "AAA", success: {
                    
                    self.searchBar.becomeFirstResponder()
                }) { (error) in
                    let alert = UIAlertController(title: "Error", message: error.message(), preferredStyle: .alert)
                    let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
                
        })
        
        
    }
    
}







