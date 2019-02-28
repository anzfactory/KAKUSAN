//
//  KAKUSANConfirmationDelegate.swift
//  KAKUSAN
//
//  Created by sasato on 2019/02/28.
//

import UIKit

public typealias KAKUSANHandler = (KAKUSAN.Body?) -> Void

public protocol KAKUSANConfirmationDelegate: NSObjectProtocol {
    
    func kakusanConfirmation(screenshot: UIImage, handler: @escaping KAKUSANHandler)
}
