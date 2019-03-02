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
        
        func confirm(hasDelegate: Bool) {
            
            if hasDelegate {
                confirmWithConfirmationDelegate()
            } else {
                confirmWithAlertController()
            }
        }
        
        let hasDelegate = confirmationDelegate != nil
        if let delay = config.alert.delay {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                confirm(hasDelegate: hasDelegate)
            }
        } else {
            confirm(hasDelegate: hasDelegate)
        }
    }
    
    private func confirmWithConfirmationDelegate() {
        
        guard let screenshot = ScreenshotMaker.make(watermark: config.watermark) else {
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
        
        guard let screenshot = ScreenshotMaker.make(watermark: config.watermark) else {
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
