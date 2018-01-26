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
import Localize_Swift

private let historyCellId = "historyCell"

class MoreVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var listItem = [(key:String, thumb:UIImage)]()
    private var availableLanguages = Localize.availableLanguages()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(availableLanguages)
        if availableLanguages.contains("Base"){
            availableLanguages.remove(at: 0)
        }
        
        tableView.registerNib(HistoryTableViewCell.self, historyCellId)
        
        setText()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setText),
                                               name: NSNotification.Name(LCLLanguageChangeNotification),
                                               object: nil)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }
    
    // Remove the LCLLanguageChangeNotification on viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func setText() {
        
        self.title = "Setting".localized()
        
        listItem = [
            ("History",#imageLiteral(resourceName: "ic_query_builder")),
            ("Feedback",#imageLiteral(resourceName: "ic_feedback")),
            ("Other",#imageLiteral(resourceName: "ic_new_releases")),
            ("Share",#imageLiteral(resourceName: "ic_share")),
            ("Review",#imageLiteral(resourceName: "ic_star_border")),
            ("Language", #imageLiteral(resourceName: "ic_language"))
        ]
        
        tableView.reloadData()
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
    
    func shareAction(){
        
        let activityVC = UIActivityViewController(activityItems: [LINK_SHARE], applicationActivities: nil)
        
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func rateApp() {
        
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else if #available(iOS 10.0, *) {
            
            guard let url = URL(string : "https://itunes.apple.com/app/\(APP_ID)") else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
    }
    
    func changeLanguage() {
        
        let lastLang = Localize.currentLanguage()
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        for language in availableLanguages {
            let displayName = Localize.displayNameForLanguage(language)
            let languageAction = UIAlertAction(title: displayName, style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                
                if language != lastLang{
                    Localize.setCurrentLanguage(language)
                }
//                Global.shared.clearLanguage()
//                Global.shared.addLanguage(lang: language)
            })
            actionSheet.addAction(languageAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {
            (alert: UIAlertAction) -> Void in
        })
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
}

//MARK: - TableView DataSource

extension MoreVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: historyCellId, for: indexPath) as! HistoryTableViewCell
        cell.setContentCell(listItem[indexPath.row])
        
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
        
        let key = listItem[indexPath.row].key
        
        switch key {
            
        case "History":
            performSegue(withIdentifier: "sgHistory", sender: nil)
            
        case "Feedback":
                let mailComposeViewController = configuredMailComposeViewController()
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailComposeViewController, animated: true, completion: nil)
                }
            
        case "Other":
                let url = URL(string: "https://github.com/")
                UIApplication.shared.openURL(url!)
            
        case "Share":
                shareAction()
            
        case "Review":
                rateApp()
            
        case "Language":
                changeLanguage()
            
        default:
            break;
        }

    }
    

}

extension MoreVC: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
    }
}






