//
//  AppDelegate.swift
//  SceneWhisper
//
//  Created by weipo on 2017/4/4.
//  Copyright © 2017年 weipo. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        
        HSLocationManager.sharedInstance.startUpdatingLocation()
        
        UMSocialManager.default().umSocialAppkey = "597b3681f29d98160c0016ae"
        configUMSharePlatforms()
        
       
        if SWDataManager.checkUserLoginStatus() {
            self.window?.rootViewController = UINavigationController(rootViewController: SWHomeViewController.initViewController())
        } else {
            self.window?.rootViewController = SWLoginViewController.initViewController()
        }
        
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
        
        let result = UMSocialManager.default().handleOpen(url, options: options)
        
        if !result {
            //非友盟回调处理
        }
        
        return result
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        
        let result = UMSocialManager.default().handleOpen(url)
        
        if !result {
            //非友盟回调处理
        }
        
        return result

    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let result = UMSocialManager.default().handleOpen(url, sourceApplication: sourceApplication, annotation: annotation)
        
        if !result {
            //非友盟回调处理
        }
        
        return result

    }
    
    func configUMSharePlatforms() {
        
        //微信
        UMSocialManager.default().setPlaform(.wechatSession, appKey: "wx1e983d596aa9307a", appSecret: "bb1e8b676d9958f2bc6eaad7ca21f883", redirectURL: nil)
        
        //QQ
        UMSocialManager.default().setPlaform(.QQ, appKey: "1106220254", appSecret: "pYOsvUQD3ZVf3euZ", redirectURL: nil)
        
        //新浪微博
        UMSocialManager.default().setPlaform(.sina, appKey: "1748372300", appSecret: "6ede8714da71cfc853228df52cfa9088", redirectURL: "https://api.weibo.com/oauth2/default.html")
        
    }
    
    
}

