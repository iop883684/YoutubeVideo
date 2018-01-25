//
//  Global.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 12/28/17.
//  Copyright © 2017 Lac Tuan. All rights reserved.
//

import Foundation
import Firebase

class Global {
    
    var pref: UserDefaults!
    
    static let shared : Global = {
        let instanceGl = Global()
        return instanceGl
    }()
    
    var loadingDoneCallback: (() -> ())?
    var fetchComplete: Bool = false
    
    var timeOutApp: Double!
    var watchHistory = 0
    
    let appName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as AnyObject
    let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as AnyObject
    
    private init() {
        loadDefaultValues()
        fetchCloudValues()
        pref = UserDefaults.standard
    }
    
    func loadDefaultValues() {
        let appDefaults: [String: NSObject] = [
            "message" : "fix bug" as NSObject
        ]
        RemoteConfig.remoteConfig().setDefaults(appDefaults)
    }
    
    func fetchCloudValues() {

        RemoteConfig.remoteConfig().fetch(withExpirationDuration: 43200) {
            [weak self] (status, error) in
            
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil else {
                print (error ?? "")
                return
            }
            
            RemoteConfig.remoteConfig().activateFetched()
            print ("Retrieved values from the cloud!")
            print ("Message: \(RemoteConfig.remoteConfig().configValue(forKey: "message").stringValue!)")
            print("Version: \(RemoteConfig.remoteConfig().configValue(forKey: "version").stringValue!)")
            print("Disable: \(RemoteConfig.remoteConfig().configValue(forKey: "disable").stringValue!)")
            
            strongSelf.fetchComplete = true
            strongSelf.loadingDoneCallback?()
        }
    }
    
    func clearFavorite(){
        
        pref.set(nil, forKey: "favorites")
        
    }
    
    func clearHistory(){
        
        pref.set(nil, forKey: "videoWatched")
        
    }
    
    func addFavoriteChannel(dict: [String: String]) {
        var favorites = [[String: String]]()
        if let _favorites = pref.object(forKey: "favorites") as? [[String: String]] {
            favorites = _favorites
        }
        favorites.append(dict)
        
        pref.set(favorites, forKey: "favorites")
    }
    
    func getFavoriteChannel() -> [[String: String]]! {
        guard let favorites = pref.object(forKey: "favorites") as? [[String: String]] else { return nil }
        return favorites
    }
    
    func deleteFavoriteChannel(index: Int) {
        guard var favorites = pref.object(forKey: "favorites") as? [[String: String]] else { return }
        favorites.remove(at: index)
        
        pref.set(favorites, forKey: "favorites")
    }
    
    func addIdVideoWatched(id: String) {
        
        var videoWatched = [String]()
        if let _videoWatched = pref.object(forKey: "videoWatched") as? [String] {
            videoWatched = _videoWatched
        }
        videoWatched.append(id)
        
        pref.set(videoWatched, forKey: "videoWatched")
    }
    
    func getIdVideoWatched() -> [String]! {
        guard let videoWatched = pref.object(forKey: "videoWatched") as? [String] else { return nil }
        return videoWatched
    }
    
    func addLanguage(lang: String) {
        
        var languageDevice: String!
        if let language = pref.object(forKey: "language") as? String {
            languageDevice = language
        }
        languageDevice = lang
        
        pref.set(languageDevice, forKey: "language")
    }
    
    func getLanguage() -> String! {
        
        guard let language = pref.object(forKey: "language") as? String else { return "" }
        
        return language
    }
    
    func clearLanguage(){
        
        pref.set(nil, forKey: "language")
        
    }
    

}














