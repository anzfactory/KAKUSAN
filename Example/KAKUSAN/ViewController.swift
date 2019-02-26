//
//  ViewController.swift
//  KAKUSAN
//
//  Created by anzfactory on 02/25/2019.
//  Copyright (c) 2019 anzfactory. All rights reserved.
//

import KAKUSAN
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var config = KAKUSAN.Config(text: "Share Text", url: URL(string: "https://example.com/"))
        config.alert.title = "Share!"
        config.alert.message = "Would you like to share screenshot?"
        config.alert.style = .actionSheet
        config.alert.action.positiveText = "Done"
        config.alert.action.negativeText = "Cancel"
//        KAKUSAN.shared.configure(config)
        
        KAKUSAN.shared.start()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        #if targetEnvironment(simulator)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                NotificationCenter.default.post(name: UIApplication.userDidTakeScreenshotNotification, object: nil)
            }
        #endif
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        KAKUSAN.shared.stop()
    }
}

