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
        let tabBarItemHome =  UITabBarItem(tabBarSystemItem: .topRated, tag: 10)
        navigationHome.tabBarItem = tabBarItemHome
        
        // Favorite
        let navigationFav = UIStoryboard(name: Storyboard.Favorite.name, bundle: nil).instantiateInitialViewController()!
        let tabBarItemFav  =  UITabBarItem(tabBarSystemItem: .favorites , tag: 40)
        navigationFav.tabBarItem = tabBarItemFav
        
        // Search
        let navigationSearch = UIStoryboard(name: Storyboard.Search.name, bundle: nil).instantiateInitialViewController()!
        let tabBarItemSearch  =  UITabBarItem(tabBarSystemItem: .search, tag: 20)
        navigationSearch.tabBarItem = tabBarItemSearch
        
        // User
        let navigationUser = UIStoryboard(name: Storyboard.User.name, bundle: nil).instantiateInitialViewController()!
//        let userImg = #imageLiteral(resourceName: "user")
        let tabBarItemUser =  UITabBarItem(tabBarSystemItem: .more, tag: 30)
        navigationUser.tabBarItem = tabBarItemUser
        
        // set list childs controller to tabbar
        let controllers = [navigationHome, navigationFav ,navigationSearch, navigationUser]
        self.viewControllers = controllers
        self.hideTabbar(hide: false)
    }
}

