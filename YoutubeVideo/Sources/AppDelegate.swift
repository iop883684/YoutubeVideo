//
//  AppDelegate.swift
//  YoutubeVideo
//
//  Created by Lac Tuan on 12/25/17.
//  Copyright © 2017 Lac Tuan. All rights reserved.
//

import UIKit
import Firebase
import Localize_Swift
import UserNotifications
import FirebaseMessaging
import PKHUD
import SwiftRater

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.statusBarStyle = .default
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in
                    
                    print("did have permission push noti")
            })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()

        
        let _ = Global.shared
        
        // Swift Rater
        
        SwiftRater.daysUntilPrompt = 1
        SwiftRater.usesUntilPrompt = 5
        SwiftRater.significantUsesUntilPrompt = 3
        SwiftRater.daysBeforeReminding = 1
        SwiftRater.showLaterButton = true
        SwiftRater.debugMode = false
        SwiftRater.appLaunched()
        
        return true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print(token)
    }
    
    private func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }


    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print full message.
        
        print(userInfo)

        if let urlStr = userInfo["url"] as? String {
            
            let url = URL(string: urlStr)
            UIApplication.shared.openURL(url!)
            
        } else if let videoId = userInfo["videoId"] as? String {
            
            guard videoId.count == 11 else{
                HUD.flash(.label("VideoID wrong format"), delay: 1)
                return
            }
            
            //dismiss previous player if nessessary
            window?.rootViewController?.dismiss(animated: false, completion: nil)
            
            let sb = UIStoryboard(name: Storyboard.Home.name, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "VideoPlayerVC") as! VideoPlayerVC
            
            vc.id = videoId
            window?.rootViewController?.present(vc, animated: true, completion: nil)
            
        }
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    //MARK: - AppActive
    
    func applicationWillResignActive(_ application: UIApplication) {
        let date = Date()
        let time = date.timeIntervalSince1970
        Global.shared.timeOutApp = time
    }

}

