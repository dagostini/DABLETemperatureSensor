//
//  InterfaceController.swift
//  DABLETemperature Extension
//
//  Created by Dejan on 13/02/2017.
//  Copyright © 2017 Dejan. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController {
    
    var watchSession: WCSession? {
        didSet {
            if let session = watchSession {
                session.delegate = self
                session.activate()
            }
        }
    }
    
    @IBOutlet var temperatureLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        watchSession = WCSession.default()
    }
}

extension InterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Session activation did complete")
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("watch received app context: ", applicationContext)
        if let temperature = applicationContext[DataKey.Temperature] as? String {
            self.temperatureLabel.setText(temperature + "℃")
        }
        
        if let connected = applicationContext[DataKey.BLEConnected] as? Bool {
            self.temperatureLabel.setTextColor(connected == true ? UIColor.white : UIColor.red)
        }
    }
}

