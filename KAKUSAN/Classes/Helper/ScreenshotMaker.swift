//
//  ScreenshotMaker.swift
//  KAKUSAN
//
//  Created by sasato on 2019/02/25.
//

import UIKit

struct ScreenshotMaker {
    
    private init() { }
    
    static func make() -> UIImage? {
        
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(keyWindow.layer.frame.size, false, UIScreen.main.scale)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        
        keyWindow.layer.render(in: context)
        
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return screenshot
    }
}
