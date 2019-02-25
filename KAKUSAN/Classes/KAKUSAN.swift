//
//  KAKUSAN.swift
//  KAKUSAN
//
//  Created by sasato on 2019/02/25.
//

import UIKit

public class KAKUSAN {
    
    public static let shared: KAKUSAN = KAKUSAN()
    
    private let userDidDenyUserDefaultsKey: String = "KAKUSANN.userDidDenyUserDefaultsKey"
    
    private var config: Config = Config(text: nil, url: nil)
    private var isStarted: Bool = false
    
    private init() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(type(of: self).userDidTakeScreenshotNotified(notification:)),
            name: UIApplication.userDidTakeScreenshotNotification,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public func start() {
        
        isStarted = true
    }
    
    public func stop() {
        
        isStarted = false
    }
}

extension KAKUSAN {
    
    private func confirmSharingScreenshot() {
        
        guard isStarted else {
            return
        }
        
        guard let topViewController = VCFinder.findTopViewController() else {
            return
        }
        
        let alertVC = UIAlertController(title: config.alert.title, message: config.alert.message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: config.alert.action.positiveText, style: .default, handler: { _ in
            self.takeScreenshot()
        }))
        alertVC.addAction(UIAlertAction(title: config.alert.action.negativeText, style: .cancel, handler: nil))
        topViewController.present(alertVC, animated: true, completion: nil)
    }
    
    private func takeScreenshot() {
        
        guard let screenshot = ScreenshotMaker.make() else {
            return
        }
        
        shareScreenshot(screenshot)
    }
    
    private func shareScreenshot(_ screenshot: UIImage) {
        
        guard let topViewController = VCFinder.findTopViewController() else {
            return
        }
        
        var items: [Any] = [screenshot]
        if let text = config.text {
            items.append(text)
        }
        if let url = config.url {
            items.append(url)
        }
        
        let activity = UIActivityViewController(activityItems: items, applicationActivities: nil)
        topViewController.present(activity, animated: true, completion: nil)
    }
}

@objc extension KAKUSAN {
    
    private func userDidTakeScreenshotNotified(notification: Notification) {
        
        confirmSharingScreenshot()
    }
}

extension KAKUSAN {
    
    struct Config {
        
        var text: String?
        var url: URL?
        
        var alert: Alert
        
        init(text: String?, url: URL?, alert: Alert = Alert()) {
            
            self.text = text
            self.url = url
            self.alert = alert
        }
    }
}

extension KAKUSAN.Config {
    
    struct Alert {
        
        var title: String? = "Connfirm"
        var message: String? = "Share screenshot?"
        var action: Action = Action()
    }
}

extension KAKUSAN.Config.Alert {
    
    struct Action {
        
        var positiveText: String = "Share"
        var negativeText: String = "Not now"
    }
}
