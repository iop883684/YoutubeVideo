//
//  MoreVC.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/18/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit
import MessageUI
import StoreKit

private let historyCellId = "historyCell"
private let feedBackCellId = "feedBackCell"
private let otherCellId = "otherCell"
private let shareCellId = "shareCell"
private let rateCellId = "rateCell"

class MoreVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerNib(HistoryTableViewCell.self, historyCellId)
        tableView.registerNib(FeedBackTableViewCell.self, feedBackCellId)
        tableView.registerNib(OtherTableViewCell.self, otherCellId)
        tableView.registerNib(ShareTableViewCell.self, shareCellId)
        tableView.registerNib(RateTableViewCell.self, rateCellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.isStatusBarHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = UIColor.black
        navigationItem.backBarButtonItem = backItem
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.navigationBar.tintColor = UIColor.red
        let title = "[\(Global.shared.appName)] Feedback"
        var messeageBody = String()
        messeageBody.append("\n\n\n------------------------------------\n")
        messeageBody.append("System version: \(UIDevice.current.systemVersion)\n")
        messeageBody.append("Model name: \(UIDevice.current.modelName)\n")
        messeageBody.append("App version: \(Global.shared.version)\n")
        messeageBody.append("App build: \(Global.shared.build)\n")
        
        mailComposerVC.setToRecipients(["aababababababa@gmail.com"])
        mailComposerVC.setSubject(title)
        mailComposerVC.setMessageBody(messeageBody, isHTML: false)
        
        return mailComposerVC
    }
    
    func share(){
        
        let activityVC = UIActivityViewController(activityItems: [LINK_SHARE], applicationActivities: nil)
        
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func rateApp(appId: String) {
        
        guard let url = URL(string : "https://itunes.apple.com/app/\(APP_ID)") else {
            return
        }
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

//MARK: - TableView DataSource

extension MoreVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch  section {
        case 0:
            return 1
        case 1:
            return 4
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: historyCellId, for: indexPath) as! HistoryTableViewCell
            
            return cell
            
        case 1:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: feedBackCellId, for: indexPath) as! FeedBackTableViewCell
                
                return cell
            }else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: otherCellId, for: indexPath) as! OtherTableViewCell
                
                return cell
            } else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: shareCellId, for: indexPath) as! ShareTableViewCell
                
                return cell
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: rateCellId, for: indexPath) as! RateTableViewCell
                
                return cell
            }
            
        default:
            return UITableViewCell()
        }
    }
}

//MARK: - TableView Delegate

extension MoreVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
            
        case 0:
            performSegue(withIdentifier: "sgHistory", sender: nil)
            
        case 1:
            if indexPath.row == 0 {
                let mailComposeViewController = configuredMailComposeViewController()
                
                if MFMailComposeViewController.canSendMail() {
                    
                    self.present(mailComposeViewController, animated: true, completion: nil)
                }
            } else if indexPath.row == 1 {
                
                let url = URL(string: "https://github.com/")
                UIApplication.shared.openURL(url!)
                
            } else if indexPath.row == 2 {
                
                share()
            } else {
                rateApp(appId: APP_ID)
            }
            
        default:
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 3))
        view.backgroundColor = UIColor(red: 240/255, green: 241/255, blue: 242/255, alpha: 1)
        return view
    }
}

extension MoreVC: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
    }
}






