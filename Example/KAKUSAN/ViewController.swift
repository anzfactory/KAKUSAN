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
        
        KAKUSAN.shared.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        KAKUSAN.shared.stop()
    }
}

