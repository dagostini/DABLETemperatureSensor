//
//  WatchManager.swift
//  DABLETemperatureSensor
//
//  Created by Dejan on 16/02/2017.
//  Copyright © 2017 Dejan. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchManager: NSObject {
    
    public var bleManager: BLEManagable? {
        willSet {
            if newValue == nil {
                bleManager?.removeDelegate(self)
            }
        }
        
        didSet {
            bleManager?.addDelegate(self)
        }
    }
    
    fileprivate var watchSession: WCSession?
    
    override init() {
        super.init()
        watchSession = WCSession.default()
        watchSession?.delegate = self // We don't really need this, we'll just use it for debug.
        watchSession?.activate()
    }
    
    deinit {
        bleManager?.removeDelegate(self)
    }
}

// MARK: BLEManagerDelegate
extension WatchManager: BLEManagerDelegate {
    
    func bleManagerDidConnect(_ manager: BLEManagable) {
        sendDictionary([DataKey.BLEConnected: true])
    }
    
    func bleManagerDidDisconnect(_ manager: BLEManagable) {
        sendDictionary([DataKey.BLEConnected: false])
    }
    
    func bleManager(_ manager: BLEManagable, receivedDataString dataString: String) {
        sendDictionary([DataKey.Temperature: dataString, DataKey.BLEConnected: true])
    }
    
    private func sendDictionary(_ dict: [String: Any]) {
        do {
            try self.watchSession?.updateApplicationContext(dict)
        } catch {
            print("Error sending dictionary \(dict) to Apple Watch!")
        }
    }
}

// MARK: WCSessionDelegate
extension WatchManager: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Session activation did complete")
    }
    
    public func sessionDidBecomeInactive(_ session: WCSession) {
        print("session did become inactive")
    }
    
    public func sessionDidDeactivate(_ session: WCSession) {
        print("session did deactivate")
    }
}

