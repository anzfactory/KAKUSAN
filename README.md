# KAKUSAN

[![CI Status](https://img.shields.io/travis/anzfactory/KAKUSAN.svg?style=flat)](https://travis-ci.org/anzfactory/KAKUSAN)
[![Version](https://img.shields.io/cocoapods/v/KAKUSAN.svg?style=flat)](https://cocoapods.org/pods/KAKUSAN)
[![License](https://img.shields.io/cocoapods/l/KAKUSAN.svg?style=flat)](https://cocoapods.org/pods/KAKUSAN)
[![Platform](https://img.shields.io/cocoapods/p/KAKUSAN.svg?style=flat)](https://cocoapods.org/pods/KAKUSAN)

![ANZSingleImageViewer](https://github.com/anzfactory/KAKUSAN/blob/master/Screenshots/KAKUSAN.gif)

Automatically detect when a user takes a screenshot, and share that screenshot.  
(with "UIActivityViewController")

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- Xcode v10.1
- Swift v4.2
- iOS v11.0+

## Installation

KAKUSAN is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'KAKUSAN'
```

## Usage

```swift
KAKUSAN.shared.start()
```

### Coniguration

```swift
var config = KAKUSAN.Config(text: "Share Text", url: URL(string: "https://example.com/"))
config.alert.title = "Share!"
config.alert.message = "Would you like to share screenshot?"
config.alert.style = .actionSheet
config.alert.action.positiveText = "Done"
config.alert.action.negativeText = "Cancel"
config.watermark = KAKUSAN.Watermark(
    image: UIImage(named: "watermark")!,
    alpha: 0.4,
    position: .bottomRight(padding: 16.0)
)
KAKUSAN.shared.configure(config)
```

### Customize confirmation dialog

```swift
KAKUSAN.shared.confirmationDelegate = self

// ConfirmationDelegate
extension ViewController: KAKUSANConfirmationDelegate {
    
    func kakusanConfirmation(screenshot: UIImage, handler: @escaping KAKUSANHandler) {
        // show custom dialog
    }
}
```

## Author

anzfactory, anz.factory@gmail.com

## License

KAKUSAN is available under the MIT license. See the LICENSE file for more info.
