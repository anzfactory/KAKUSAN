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
    
    private var handler: KAKUSANHandler?
    private var overlay: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var config = KAKUSAN.Config(text: "Share Text", url: URL(string: "https://example.com/"))
        config.alert.title = "Share!"
        config.alert.message = "Would you like to share screenshot?"
        config.alert.delay = 2.0
        config.alert.style = .actionSheet
        config.alert.action.positiveText = "Done"
        config.alert.action.negativeText = "Cancel"
        // set watermark
        config.watermark = KAKUSAN.Watermark(
            image: UIImage(named: "anzfactory")!,
            alpha: 0.8,
            position: .bottomRight(padding: 16.0)
        )
//        KAKUSAN.shared.configure(config)
        
        // use custom view instead of UIAlertController
//        KAKUSAN.shared.confirmationDelegate = self
        
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
    
    private func confirm(screenshot: UIImage) {
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        let overlay: UIView = {
            let view = UIView(frame: CGRect(origin: .zero, size: window.bounds.size))
            view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            return view
        }()
        
        let imageView: UIImageView = {
            let view = UIImageView(frame: .zero)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.clipsToBounds = true
            view.contentMode = .scaleAspectFit
            view.layer.cornerRadius = 10.0
            view.layer.borderColor = UIColor.gray.cgColor
            return view
        }()
        imageView.image = screenshot
        overlay.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: overlay.leftAnchor, constant: 60.0),
            imageView.rightAnchor.constraint(equalTo: overlay.rightAnchor, constant: -60.0),
            imageView.centerYAnchor.constraint(equalTo: overlay.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: screenshot.size.width / screenshot.size.height)
        ])
        
        let button: UIButton = {
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("Share!!", for: .normal)
            button.setTitleColor(.darkText, for: .normal)
            button.backgroundColor = .white
            return button
        }()
        button.addTarget(self, action: #selector(type(of: self).tapButton), for: .touchUpInside)
        overlay.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            button.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8.0)
        ])
        
        window.addSubview(overlay)
        self.overlay = overlay
    }
    
    @objc private func tapButton() {
        
        guard let handler = self.handler else {
            return
        }
        
        handler(nil)
        
//        let body = KAKUSAN.Body(text: "customize text", url: URL(string: "https://example.com/path/"))
//        handler(body)
        
        overlay?.removeFromSuperview()
        overlay = nil
    }
}

extension ViewController: KAKUSANConfirmationDelegate {
    
    func kakusanConfirmation(screenshot: UIImage, handler: @escaping KAKUSANHandler) {
        self.handler = handler
        confirm(screenshot: screenshot)
    }
}
