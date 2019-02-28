//
//  KAKUSAN.swift
//  KAKUSAN
//
//  Created by sasato on 2019/02/25.
//

import UIKit

public class KAKUSAN {
    
    public static let shared: KAKUSAN = KAKUSAN()
    
    public weak var confirmationDelegate: KAKUSANConfirmationDelegate?
    
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
        
        if self.confirmationDelegate == nil {
            confirmWithAlertController()
        } else {
            confirmWithConfirmationDelegate()
        }
    }
    
    private func confirmWithConfirmationDelegate() {
        
        guard let screenshot = ScreenshotMaker.make() else {
            return
        }
        
        self.confirmationDelegate?.kakusanConfirmation(screenshot: screenshot, handler: { [weak self] (body) in
            
            guard let this = self else {
                return
            }
            
            this.shareScreenshot(screenshot, body: body ?? this.config.body)
        })
    }
    
    private func confirmWithAlertController() {
        
        guard let topViewController = VCFinder.findTopViewController() else {
            return
        }
        
        let alertVC = UIAlertController(title: config.alert.title, message: config.alert.message, preferredStyle: config.alert.style)
        alertVC.addAction(UIAlertAction(title: config.alert.action.positiveText, style: .default, handler: { _ in
            self.takeScreenshot()
        }))
        alertVC.addAction(UIAlertAction(title: config.alert.action.negativeText, style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertVC.popoverPresentationController?.sourceView = topViewController.view
            alertVC.popoverPresentationController?.sourceRect = CGRect(
                origin: CGPoint(x: topViewController.view.bounds.width * 0.5, y: topViewController.view.bounds.height),
                size: .zero
            )
            alertVC.popoverPresentationController?.permittedArrowDirections = []
        }
        
        topViewController.present(alertVC, animated: true, completion: nil)
    }
    
    private func takeScreenshot() {
        
        guard let screenshot = ScreenshotMaker.make() else {
            return
        }
        
        shareScreenshot(screenshot, body: config.body)
    }
    
    private func shareScreenshot(_ screenshot: UIImage, body: Body) {
        
        guard let topViewController = VCFinder.findTopViewController() else {
            return
        }
        
        var items: [Any] = [screenshot]
        if let text = body.text {
            items.append(text)
        }
        if let url = body.url {
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
        
        public var alert: Alert
        public var body: Body
        
        public init(text: String?, url: URL?, alert: Alert = Alert()) {
            
            body = Body(text: text, url: url)
            self.alert = alert
        }
    }
}

extension KAKUSAN {
    
    public struct Body {
        
        public var text: String?
        public var url: URL?
        
        public init(text: String?, url: URL?) {
            self.text = text
            self.url = url
        }
    }
}

extension KAKUSAN.Config {
    
    public struct Alert {
        
        public var title: String? = "Connfirm"
        public var message: String? = "Share screenshot?"
        public var style: UIAlertController.Style = .alert
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
