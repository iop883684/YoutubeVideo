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

class MoreVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    
    var arrayTitle = [[String]]()
    var arrayThumb = [[UIImage]]()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        arrayTitle = [["Đã xem"],
                     ["Góp ý","Ứng dụng khác","Chia sẻ","Đánh giá"]]
        
        arrayThumb = [[#imageLiteral(resourceName: "ic_query_builder")],
                     [#imageLiteral(resourceName: "ic_feedback"), #imageLiteral(resourceName: "ic_share"), #imageLiteral(resourceName: "ic_share"), #imageLiteral(resourceName: "ic_star_rate_18pt")]]
        
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerNib(HistoryTableViewCell.self, historyCellId)
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
        return arrayTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayTitle[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: historyCellId, for: indexPath) as! HistoryTableViewCell
        
        let title = arrayTitle[indexPath.section][indexPath.row]
        let img = arrayThumb[indexPath.section][indexPath.row]

        cell.configure(title, img)
        
        return cell
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
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 3))
//        view.backgroundColor = UIColor(red: 240/255, green: 241/255, blue: 242/255, alpha: 1)
//        return view
//    }
}

extension MoreVC: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
    }
}






