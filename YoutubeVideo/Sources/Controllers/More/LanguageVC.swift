//
//  LanguageVC.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 1/23/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit
import Localize_Swift

class LanguageVC: UIViewController {
    
    @IBOutlet weak var switchBtn: UIButton!
    
    private let availableLanguages = Localize.availableLanguages()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setText()
    }
    
    // MARK: IBActions
    @IBAction func doChangeLanguage(_ sender: AnyObject) {
        let actionSheet = UIAlertController(title: nil, message: "Switch Language".localized(), preferredStyle: UIAlertControllerStyle.actionSheet)
        for language in availableLanguages {
            let displayName = Localize.displayNameForLanguage(language)
            let languageAction = UIAlertAction(title: displayName, style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                Localize.setCurrentLanguage(language)
                Global.shared.clearLanguage()
                Global.shared.addLanguage(lang: language)
            })
            actionSheet.addAction(languageAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {
            (alert: UIAlertAction) -> Void in
        })
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }

    
    func setText() {
        
        self.title = "Language".localized()
        switchBtn.setTitle("Switch Language".localized(), for: .normal)
    }
}
