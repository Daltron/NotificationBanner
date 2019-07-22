/*
 
 The MIT License (MIT)
 Copyright (c) 2018 Denis Kozhukhov
 
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
import SnapKit

open class FloatingNotificationBanner: GrowingNotificationBanner {
    
    public init(title: String? = nil,
                subtitle: String? = nil,
                titleFont: UIFont? = nil,
                titleColor: UIColor? = nil,
                titleTextAlign: NSTextAlignment? = nil,
                subtitleFont: UIFont? = nil,
                subtitleColor: UIColor? = nil,
                subtitleTextAlign: NSTextAlignment? = nil,
                leftView: UIView? = nil,
                rightView: UIView? = nil,
                style: BannerStyle = .info,
                colors: BannerColorsProtocol? = nil,
                iconPosition: IconPosition = .center) {

        super.init(title: title, subtitle: subtitle, leftView: leftView, rightView: rightView, style: style, colors: colors, iconPosition: iconPosition)
        
        if let titleFont = titleFont {
            self.titleFont = titleFont
            titleLabel!.font = titleFont
        }
        
        if let titleColor = titleColor {
            titleLabel!.textColor = titleColor
        }
        
        if let titleTextAlign = titleTextAlign {
            titleLabel!.textAlignment = titleTextAlign
        }
        
        if let subtitleFont = subtitleFont {
            self.subtitleFont = subtitleFont
            subtitleLabel!.font = subtitleFont
        }
        
        if let subtitleColor = subtitleColor {
            subtitleLabel!.textColor = subtitleColor
        }
        
        if let subtitleTextAlign = subtitleTextAlign {
            subtitleLabel!.textAlignment = subtitleTextAlign
        }
    }
    
    public init(customView: UIView) {
        super.init(style: .customView)
        self.customView = customView
        
        contentView.addSubview(customView)
        customView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        spacerView.backgroundColor = customView.backgroundColor
    }
    
    /**
     Convenience function to display banner with non .zero default edge insets
     */
    public func show(queuePosition: QueuePosition = .back,
                     bannerPosition: BannerPosition = .top,
                     queue: NotificationBannerQueue = NotificationBannerQueue.default,
                     on viewController: UIViewController? = nil,
                     edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8),
                     cornerRadius: CGFloat? = nil,
                     shadowColor: UIColor = .black,
                     shadowOpacity: CGFloat = 1,
                     shadowBlurRadius: CGFloat = 0,
                     shadowCornerRadius: CGFloat = 0,
                     shadowOffset: UIOffset = .zero,
                     shadowEdgeInsets: UIEdgeInsets? = nil) {

        self.bannerEdgeInsets = edgeInsets
        
        if let cornerRadius = cornerRadius {
            contentView.layer.cornerRadius = cornerRadius
            contentView.subviews.last?.layer.cornerRadius = cornerRadius
        }
        
        if style == .customView, let customView = contentView.subviews.last {
           customView.backgroundColor = customView.backgroundColor?.withAlphaComponent(transparency)
        }

        show(queuePosition: queuePosition,
             bannerPosition: bannerPosition,
             queue: queue,
             on: viewController)
        
        applyShadow(withColor: shadowColor,
                    opacity: shadowOpacity,
                    blurRadius: shadowBlurRadius,
                    cornerRadius: shadowCornerRadius,
                    offset: shadowOffset,
                    edgeInsets: shadowEdgeInsets)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension FloatingNotificationBanner {
    
    /**
     Add shadow for notification with specified parameters.
     */
    private func applyShadow(withColor color: UIColor = .black,
                             opacity: CGFloat = 1,
                             blurRadius: CGFloat = 0,
                             cornerRadius: CGFloat = 0,
                             offset: UIOffset = .zero,
                             edgeInsets: UIEdgeInsets? = nil) {
        guard blurRadius > 0 else { return }
        contentView.layer.shadowColor = color.cgColor
        contentView.layer.shadowOpacity = Float(opacity)
        contentView.layer.shadowRadius = blurRadius
        contentView.layer.shadowOffset = CGSize(width: offset.horizontal, height: offset.vertical)
        
        if let edgeInsets = edgeInsets {
            var shadowRect = CGRect(origin: .zero, size: bannerPositionFrame.startFrame.size)
            shadowRect.size.height -= (spacerViewHeight() - spacerViewDefaultOffset) // to proper handle spacer height affects
            shadowRect.origin.x += edgeInsets.left
            shadowRect.origin.y += edgeInsets.top
            shadowRect.size.width -= (edgeInsets.left + edgeInsets.right)
            shadowRect.size.height -= (edgeInsets.top + edgeInsets.bottom)
            contentView.layer.shadowPath = UIBezierPath(roundedRect: shadowRect, cornerRadius: cornerRadius).cgPath
        }
    }
    
}
