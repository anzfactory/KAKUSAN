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
    
    public func configure(_ config: Config) {
        
        self.config = config
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
    
    public struct Config {
        
        public var text: String?
        public var url: URL?
        
        public var alert: Alert
        
        public init(text: String?, url: URL?, alert: Alert = Alert()) {
            
            self.text = text
            self.url = url
            self.alert = alert
        }
    }
}

extension KAKUSAN.Config {
    
    public struct Alert {
        
        public var title: String? = "Connfirm"
        public var message: String? = "Share screenshot?"
        public var action: Action = Action()
        
        public init() { }
    }
}

extension KAKUSAN.Config.Alert {
    
    public struct Action {
        
        public var positiveText: String = "Share"
        public var negativeText: String = "Not now"
        
        public init() { }
    }
}
