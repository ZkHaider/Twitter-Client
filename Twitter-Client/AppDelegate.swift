//
//  AppDelegate.swift
//  Twitter-Client
//
//  Created by Haider Khan on 10/29/16.
//  Copyright © 2016 ZkHaider. All rights reserved.
//

import UIKit
import Material

// Storyboard
let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Register a logout notification
        NotificationCenter.default.addObserver(self, selector: #selector(userDidLogout), name: NSNotification.Name(rawValue: userDidLogoutNotification), object: nil)
        
        switchControllers()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        TwitterClient.instance.openURL(url: url)
        return true
    }

    @objc func userDidLogout() {
        User.currentUser = nil
        switchControllers()
    }

}

extension AppDelegate {
    
    func switchControllers() {
        // Override point for customization after application launch.
        if User.currentUser != nil {
            window = UIWindow(frame: Device.bounds)
            window!.rootViewController = TwitterFeedController(rootViewController: RootViewController())
            window!.makeKeyAndVisible()
        } else {
            window = UIWindow(frame: Device.bounds)
            window!.rootViewController = mainStoryboard.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
            window!.makeKeyAndVisible()
        }

    }
    
}

