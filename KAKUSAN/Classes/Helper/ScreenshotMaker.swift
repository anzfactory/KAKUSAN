//
//  ScreenshotMaker.swift
//  KAKUSAN
//
//  Created by sasato on 2019/02/25.
//

import UIKit

struct ScreenshotMaker {
    
    private init() { }
    
    static func make(watermark: KAKUSAN.Watermark?) -> UIImage? {
        
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return nil
        }
        
        let frame = keyWindow.layer.frame
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        
        keyWindow.layer.render(in: context)
        
        if let watermark = watermark {
            
            let origin: CGPoint
            switch watermark.position {
            case .topLeft(let padding):
                origin = CGPoint(x: padding, y: padding)
            case .topRight(let padding):
                origin = CGPoint(x: frame.size.width - watermark.image.size.width - padding, y: padding)
            case .bottomLeft(let padding):
                origin = CGPoint(x: padding, y: frame.height - watermark.image.size.height - padding)
            case .bottomRight(let padding):
                origin = CGPoint(x: frame.size.width - watermark.image.size.width - padding, y: frame.height - watermark.image.size.height - padding)
            }
            
            watermark.image.draw(in: CGRect(origin: origin, size: watermark.image.size), blendMode: .normal, alpha: watermark.alpha)
        }
        
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return screenshot
    }
}
