//
//  MainTabbarVC.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 12/25/17.
//  Copyright © 2017 Lac Tuan. All rights reserved.
//

import UIKit

enum TabBarType: String {
    case home
    case serach
    case user
}

class MainTabBarController: UITabBarController {
    
    // MARK: - Varialbes
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // setup
        
        self.setupStartApp()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.view.alpha = 0.0
        // setup view
        
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkTimeOut), name: .UIApplicationDidBecomeActive, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // animate when appear
        UIView.animate(withDuration: 0.5) {
            self.view.alpha = 1.0
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: .UIApplicationDidBecomeActive, object: nil)
    }
    
    deinit {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup View
    private func setupView() {
        
        self.tabBar.barTintColor = UIColor(red: 238/255, green: 242/255, blue: 241/255, alpha: 1)
    }
    
    func hideTabbar(hide: Bool?, animated: Bool = false) {
        self.tabBar.isHidden = hide ?? false
    }
    
    // MARK: - Actions
    
    // MARK: - Call Api
    
    // MARK: - Functions
    
    @objc func checkTimeOut(){
        let date = Date()
        let time = date.timeIntervalSince1970
        
        guard let timeOutApp = Global.shared.timeOutApp else { return }
        
        if time - timeOutApp >= 1 {
            print("update")
            self.setupMainApp()
        }
    }
    
    private func setupStartApp() {
        let startViewController = StartVC.getViewControllerFromStoryboard(Storyboard.Main.name)
        // set list childs controller to tabbar
        let controllers = [startViewController]
        self.viewControllers = controllers
        self.hideTabbar(hide: true)
    }
    
    func setupMainApp() {
        
        // Home
        let navigationHome = UIStoryboard(name: Storyboard.Home.name, bundle: nil).instantiateInitialViewController()!
//        let homeImg = #imageLiteral(resourceName: "home")
        let tabBarItemHome =  UITabBarItem(title: "Popular".localized(), image: #imageLiteral(resourceName: "list-simple-star-7"), tag: 10)
        navigationHome.tabBarItem = tabBarItemHome
        
        // Favorite
        let navigationFav = UIStoryboard(name: Storyboard.Favorite.name, bundle: nil).instantiateInitialViewController()!
        let tabBarItemFav  =  UITabBarItem(title: "Favorites".localized(), image: #imageLiteral(resourceName: "ic_star_36pt"), tag: 40)
        navigationFav.tabBarItem = tabBarItemFav
        
        // Search
        let navigationSearch = UIStoryboard(name: Storyboard.Search.name, bundle: nil).instantiateInitialViewController()!
        let tabBarItemSearch  =  UITabBarItem(title: "Search".localized(), image: #imageLiteral(resourceName: "ic_search_36pt"), tag: 20)
        navigationSearch.tabBarItem = tabBarItemSearch
        
        // More
        let navigationUser = UIStoryboard(name: Storyboard.More.name, bundle: nil).instantiateInitialViewController()!
//        let userImg = #imageLiteral(resourceName: "user")
        let tabBarItemUser =  UITabBarItem(title: "Setting".localized(), image: #imageLiteral(resourceName: "ic_more_horiz_36pt"), tag: 30)
        navigationUser.tabBarItem = tabBarItemUser
        
        // set list childs controller to tabbar
        let controllers = [navigationHome, navigationFav ,navigationSearch, navigationUser]
        
        self.tabBarController?.tabBar.items?[0].title = NSLocalizedString("Popular", comment: "comment")
        
        self.viewControllers = controllers
        self.hideTabbar(hide: false)
    }
}

