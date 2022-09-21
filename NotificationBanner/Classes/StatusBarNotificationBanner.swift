/*

 The MIT License (MIT)
 Copyright (c) 2017-2018 Dalton Hinterscher

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

import MarqueeLabel

@objcMembers
open class StatusBarNotificationBanner: BaseNotificationBanner {

    public override var bannerHeight: CGFloat {
        get {
            if let customBannerHeight = customBannerHeight {
                return customBannerHeight
			} else if shouldAdjustForNotchFeaturedIphone() {
				return 10.0 + heightAdjustment
            } else {
                return 40.0 + heightAdjustment
            }
        } set {
            customBannerHeight = newValue
        }
    }

	override var heightAdjustment: CGFloat {
		if #available(iOS 13.0, *), NotificationBannerUtilities.isNotchFeaturedIPhone() {
			if let keyWindow = UIApplication.shared.keyWindow {
				if bannerPosition == .top, UIApplication.shared.statusBarFrame.height != keyWindow.safeAreaInsets.top {
					return UIApplication.shared.statusBarFrame.height + 8.0
				}
			}
			return UIApplication.shared.statusBarFrame.height
		}

		return 0
	}

    override init(style: BannerStyle, colors: BannerColorsProtocol? = nil) {
        super.init(style: style, colors: colors)

        let label = MarqueeLabel()
        label.animationDelay = 2
        label.type = .leftRight
        label.font = UIFont.systemFont(ofSize: 12.5, weight: UIFont.Weight.bold)
        label.textAlignment = .center
        label.textColor = .white
        contentView.addSubview(label)

        label.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
			make.bottom.equalToSuperview().offset(-5)
        }
		titleLabel = label

        updateMarqueeLabelsDurations()
    }

    public convenience init(
        title: String,
        style: BannerStyle = .info,
        colors: BannerColorsProtocol? = nil
    ) {
        self.init(style: style, colors: colors)
        titleLabel!.text = title
    }

    public convenience init(
        attributedTitle: NSAttributedString,
        style: BannerStyle = .info,
        colors: BannerColorsProtocol? = nil
    ) {
        self.init(style: style, colors: colors)
        titleLabel!.attributedText = attributedTitle
    }

    public init(customView: UIView) {
        super.init(style: .customView)
        self.customView = customView
        
        contentView.addSubview(customView)
        customView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }

        spacerView.backgroundColor = customView.backgroundColor
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

public extension StatusBarNotificationBanner {
    
    func applyStyling(
        titleColor: UIColor? = nil,
        titleTextAlign: NSTextAlignment? = nil
    ) {
        
        if let titleColor = titleColor {
            titleLabel!.textColor = titleColor
        }
        
        if let titleTextAlign = titleTextAlign {
            titleLabel!.textAlignment = titleTextAlign
        }
    }
    
}
