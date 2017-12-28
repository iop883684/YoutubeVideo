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
    
    static let shared : Global = {
        let instanceGl = Global()
        return instanceGl
    }()
    
    var loadingDoneCallback: (() -> ())?
    var fetchComplete: Bool = false
    
    private init() {
        loadDefaultValues()
        fetchCloudValues()
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
}
