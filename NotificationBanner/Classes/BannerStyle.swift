/*
 
 The MIT License (MIT)
 Copyright (c) 2017 Dalton Hinterscher
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
 to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
 and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
 ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */
import UIKit


public struct BannerConfiguration {
    var color: UIColor
    var title: String
    var attributedTitle: NSAttributedString? = nil
    var subtitle: String? = nil
    var attributedSubtitle: NSAttributedString? = nil
    var leftView: UIView? = nil
    var rightView: UIView? = nil
    var customView: UIView? = nil
    var bannerHeight: CGFloat = 64.0
    var duration: TimeInterval = 5.0
    
    init(color: UIColor, title: String, attributedTitle: NSAttributedString? = nil, subtitle: String? = nil, attributedSubtitle: NSAttributedString? = nil, leftView: UIView? = nil, rightView: UIView? = nil, customView: UIView? = nil, bannerHeight: CGFloat = 64.0, duration: TimeInterval = 5.0) {
        self.color = color
        self.title = title
        self.attributedTitle = attributedTitle
        self.subtitle = subtitle
        self.attributedSubtitle = attributedSubtitle
        self.leftView = leftView
        self.rightView = rightView
        self.customView = customView
        self.bannerHeight = bannerHeight
        self.duration = duration
    }
    
    init(builder: (inout BannerConfiguration) -> ()) {
        self.init(color: UIColor.white, title: "")
        builder(&self)
    }
    
}

public enum BannerStyle {
    case danger
    case info
    case none
    case success
    case warning
}

extension BannerStyle {
    
    func getConfiguration(withCustomView view: UIView) -> BannerConfiguration {
        return BannerConfiguration(color: self.color, title: "", customView: view)
    }
    
    func getConfiguration(withAttributedTitle attributedTitle: NSAttributedString) -> BannerConfiguration {
        return BannerConfiguration(builder: { banner in
            banner.color = self.color
            banner.attributedTitle = attributedTitle
        })
    }

    func getConfiguration(withTitle title: String, subtitle: String? = nil, leftView: UIView? = nil, rightView: UIView? = nil) -> BannerConfiguration {
        return BannerConfiguration(builder: { banner in
            banner.title = title
            banner.color = self.color
            banner.subtitle = subtitle
            banner.leftView = leftView
            banner.rightView = rightView
        })
    }
    
    fileprivate var color: UIColor {
        switch self {
        case .danger:   return UIColor(red:0.90, green:0.31, blue:0.26, alpha:1.00)
        case .info:     return UIColor(red:0.23, green:0.60, blue:0.85, alpha:1.00)
        case .none:     return UIColor.clear
        case .success:  return UIColor(red:0.22, green:0.80, blue:0.46, alpha:1.00)
        case .warning:  return UIColor(red:1.00, green:0.66, blue:0.16, alpha:1.00)
        }
    }
}


