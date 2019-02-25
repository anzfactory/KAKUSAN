//
//  VCFinder.swift
//  KAKUSAN
//
//  Created by sasato on 2019/02/25.
//

import UIKit

struct VCFinder {
    
    private init() { }
    
    static func findTopViewController(rootViewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        guard let root = rootViewController else {
            return nil
        }
        
        if let navVC = root as? UINavigationController {
            return findTopViewController(rootViewController: navVC.visibleViewController)
        }
        
        if let tabVC = root as? UITabBarController {
            return findTopViewController(rootViewController: tabVC.selectedViewController)
        }
        
        if let presentedVC = root.presentedViewController {
            return findTopViewController(rootViewController: presentedVC)
        }
        
        return root
    }
}
