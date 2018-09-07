//
//  AppDelegate.swift
//  RestorationDemo
//
//  Created by Mac mini on 9/7/18.
//  Copyright © 2018 Mac mini. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        /*
         Returning true in application(_:shouldSaveApplicationState:) instructs the system to save the state of your views and view controllers whenever the app is backgrounded
         */
        
        // Do not restore from old data.
        return true
    }

    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        
        /*
          Returning true in application(_:shouldRestoreApplicationState:) tells the system to attempt to restore the original state when the app restarts.
         */
        // Always save state information.
        return true

    }
    
}

