//
//  AppDelegate.swift
//  DABLETemperatureSensor
//
//  Created by Dejan on 10/02/2017.
//  Copyright © 2017 Dejan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var watchManager = WatchManager()
    var bleManager: BLEManagable = BLEManager()

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        watchManager.bleManager = bleManager
        
        if let vc = window?.rootViewController as? ViewController {
            vc.bleManager = bleManager
        }
        
        return true
    }
}

