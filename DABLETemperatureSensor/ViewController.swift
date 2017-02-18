//
//  ViewController.swift
//  DABLETemperatureSensor
//
//  Created by Dejan on 10/02/2017.
//  Copyright © 2017 Dejan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var bleManager: BLEManagable?
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bleManager?.addDelegate(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        bleManager?.removeDelegate(self)
    }
}

// MARK: BLEManagerDelegate
extension ViewController: BLEManagerDelegate {
    
    func bleManagerDidConnect(_ manager: BLEManagable) {
        self.temperatureLabel.textColor = UIColor.black
    }
    func bleManagerDidDisconnect(_ manager: BLEManagable) {
        self.temperatureLabel.textColor = UIColor.red
    }
    func bleManager(_ manager: BLEManagable, receivedDataString dataString: String) {
        self.temperatureLabel.text = dataString + "℃"
    }
}

