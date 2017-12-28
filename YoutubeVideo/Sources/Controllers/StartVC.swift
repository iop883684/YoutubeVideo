//
//  StartVC.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 12/25/17.
//  Copyright © 2017 Lac Tuan. All rights reserved.
//

import UIKit

class StartVC: BaseVC {
    
    // MARK: - IBOutlet
    
    // MARK: - Varialbes
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Global.shared.fetchComplete {
            checkApp()
        }
        
        Global.shared.loadingDoneCallback = checkApp

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // check app
        //self.checkApp()
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: - Setup View
    
    // MARK: - Actions
    
    // MARK: - Call Api
    
    // MARK: - Functions
    private func checkApp() {
        
        // User module (login, register, ...)
        
        // Main app
         self.perform(#selector(StartVC.gotoMainApp), with: nil, afterDelay: 1)
    }
    
    @objc func gotoMainApp() {
        self.mainTabBarViewController?.setupMainApp()
    }
}
