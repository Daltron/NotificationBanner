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
import SnapKit

#if CARTHAGE_CONFIG
    import MarqueeLabelSwift
#else
    import MarqueeLabel
#endif

public class NotificationBanner: BaseNotificationBanner {
    
    /// Notification that will be posted when a notification banner will appear
    public static let BannerWillAppear: Notification.Name = Notification.Name(rawValue: "NotificationBannerWillAppear")
    
    /// Notification that will be posted when a notification banner did appear
    public static let BannerDidAppear: Notification.Name = Notification.Name(rawValue: "NotificationBannerDidAppear")
    
    /// Notification that will be posted when a notification banner will appear
    public static let BannerWillDisappear: Notification.Name = Notification.Name(rawValue: "NotificationBannerWillDisappear")
    
    /// Notification that will be posted when a notification banner did appear
    public static let BannerDidDisappear: Notification.Name = Notification.Name(rawValue: "NotificationBannerDidDisappear")
    
    /// Notification banner object key that is included with each Notification
    public static let BannerObjectKey: String = "NotificationBannerObjectKey"
    
    /// The bottom most label of the notification if a subtitle is provided
    public private(set) var subtitleLabel: MarqueeLabel?
    
    /// The view that is presented on the left side of the notification
    private var leftView: UIView?
    
    /// The view that is presented on the right side of the notification
    private var rightView: UIView?
    
    public init(title: String,
                subtitle: String? = nil,
                leftView: UIView? = nil,
                rightView: UIView? = nil,
                style: BannerStyle = .info,
                colors: BannerColorsProtocol? = nil) {
        
        super.init(style: style, colors: colors)
        
        if let leftView = leftView {
            contentView.addSubview(leftView)
            
            leftView.snp.makeConstraints({ (make) in
                make.top.equalToSuperview().offset(10)
                make.left.equalToSuperview().offset(10)
                make.bottom.equalToSuperview().offset(-10)
                make.width.equalTo(leftView.snp.height)
            })
        }
        
        if let rightView = rightView {
            contentView.addSubview(rightView)
            
            rightView.snp.makeConstraints({ (make) in
                make.top.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-10)
                make.bottom.equalToSuperview().offset(-10)
                make.width.equalTo(rightView.snp.height)
            })
        }
        
        let labelsView = UIView()
        contentView.addSubview(labelsView)
        
        titleLabel = MarqueeLabel()
        titleLabel!.type = .left
        titleLabel!.font = UIFont.systemFont(ofSize: 17.5, weight: UIFont.Weight.bold)
        titleLabel!.textColor = .white
        titleLabel!.text = title
        labelsView.addSubview(titleLabel!)
        
        titleLabel!.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            if let _ = subtitle {
                titleLabel!.numberOfLines = 1
            } else {
                titleLabel!.numberOfLines = 2
            }
        }
        
        if let subtitle = subtitle {
            subtitleLabel = MarqueeLabel()
            subtitleLabel!.type = .left
            subtitleLabel!.font = UIFont.systemFont(ofSize: 15.0)
            subtitleLabel!.numberOfLines = 1
            subtitleLabel!.textColor = .white
            subtitleLabel!.text = subtitle
            labelsView.addSubview(subtitleLabel!)
            
            subtitleLabel!.snp.makeConstraints { (make) in
                make.top.equalTo(titleLabel!.snp.bottom).offset(2.5)
                make.left.equalTo(titleLabel!)
                make.right.equalTo(titleLabel!)
            }
        }
        
        labelsView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            
            if let leftView = leftView {
                make.left.equalTo(leftView.snp.right).offset(padding)
            } else {
                make.left.equalToSuperview().offset(padding)
            }
            
            if let rightView = rightView {
                make.right.equalTo(rightView.snp.left).offset(-padding)
            } else {
                make.right.equalToSuperview().offset(-padding)
            }
            
            if let subtitleLabel = subtitleLabel {
                make.bottom.equalTo(subtitleLabel)
            } else {
                make.bottom.equalTo(titleLabel!)
            }
        }
        
        updateMarqueeLabelsDurations()
        
    }
    
    public convenience init(attributedTitle: NSAttributedString,
                            attributedSubtitle: NSAttributedString? = nil,
                            leftView: UIView? = nil,
                            rightView: UIView? = nil,
                            style: BannerStyle = .info,
                            colors: BannerColorsProtocol? = nil) {
        
        let subtitle: String? = (attributedSubtitle != nil) ? "" : nil
        self.init(title: "", subtitle: subtitle, leftView: leftView, rightView: rightView, style: style, colors: colors)
        titleLabel!.attributedText = attributedTitle
        subtitleLabel?.attributedText = attributedSubtitle
    }
    
    public init(customView: UIView) {
        super.init(style: .none)
        contentView.addSubview(customView)
        customView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        spacerView.backgroundColor = customView.backgroundColor
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func updateMarqueeLabelsDurations() {
        super.updateMarqueeLabelsDurations()
        subtitleLabel?.speed = .duration(CGFloat(duration - 3))
    }
    
}
