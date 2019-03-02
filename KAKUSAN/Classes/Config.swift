//
//  Config.swift
//  KAKUSAN
//
//  Created by sasato on 2019/03/02.
//

import Foundation

extension KAKUSAN {
    
    public struct Config {
        
        public var alert: Alert
        public var body: Body
        public var watermark: Watermark?
        
        public init(text: String?, url: URL?, watermark: Watermark? = nil, alert: Alert = Alert()) {
            
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
        public var delay: TimeInterval? = 1.0
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

extension KAKUSAN {
    
    public struct Watermark {
        
        public var alpha: CGFloat
        public var image: UIImage
        public var position: Position
        
        public init(image: UIImage, alpha: CGFloat = 1.0, position: Position = .bottomRight(padding: 16.0)) {
            
            self.image = image
            self.alpha = alpha
            self.position = position
        }
    }
}

extension KAKUSAN.Watermark {
    
    public enum Position {
        
        case topLeft(padding: CGFloat)
        case topRight(padding: CGFloat)
        case bottomLeft(padding: CGFloat)
        case bottomRight(padding: CGFloat)
        
        var padding: CGFloat {
            
            switch self {
            case .topLeft(let value), .topRight(let value), .bottomLeft(let value), .bottomRight(let value):
                return value
            }
        }
    }
}

extension KAKUSAN.Watermark.Position: Equatable {
    
    public static func == (lhs: KAKUSAN.Watermark.Position, rhs: KAKUSAN.Watermark.Position) -> Bool {
        
        switch (lhs, rhs) {
        case (.topLeft, topLeft), (.topRight, .topRight), (.bottomLeft, .bottomRight), (.bottomRight, .bottomRight):
            return lhs.padding == rhs.padding
        default:
            return false
        }
    }
}
