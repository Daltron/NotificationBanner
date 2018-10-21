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
import SnapKit

public class GrowingNotificationBanner: BaseNotificationBanner {
    
    /// The height of the banner when it is presented
    override public var bannerHeight: CGFloat {
        get {
            if let customBannerHeight = customBannerHeight {
                return customBannerHeight
            } else {
                // Calculate the height based on contents of labels
                
                // Determine available width for displaying the label
                var boundingWidth = UIScreen.main.bounds.width - padding * 2
                
                // Substract safeAreaInsets from width, if available
                // We have to use keyWindow to ask for safeAreaInsets as `self` only knows its' safeAreaInsets in layoutSubviews
                if #available(iOS 11.0, *), let keyWindow = UIApplication.shared.keyWindow {
                    let safeAreaOffset = keyWindow.safeAreaInsets.left + keyWindow.safeAreaInsets.right
                    
                    boundingWidth -= safeAreaOffset
                }
                
                if leftView != nil {
                    boundingWidth -= iconSize + padding
                }
                
                if rightView != nil {
                    boundingWidth -= iconSize + padding
                }
                
                let titleHeight = titleLabel?.text?.height(
                    forConstrainedWidth: boundingWidth,
                    font: UIFont.systemFont(ofSize: 17.5, weight: UIFont.Weight.bold)
                    ) ?? 0.0
                
                let subtitleHeight = subtitleLabel?.text?.height(
                    forConstrainedWidth: boundingWidth,
                    font: UIFont.systemFont(ofSize: 15.0)
                    ) ?? 0.0
                
                let statusBarHeight: CGFloat = shouldAdjustForNotchFeaturedIphone() ? 44.0 : 20.0
                let minHeight: CGFloat = shouldAdjustForNotchFeaturedIphone() ? 88.0 : 64.0
                
                var actualBannerHeight = statusBarHeight + titleHeight + subtitleHeight + bottomSpacing
                
                if !subtitleHeight.isZero {
                    actualBannerHeight += innerSpacing
                }
                
                return max(actualBannerHeight, minHeight)
            }
        } set {
            customBannerHeight = newValue
        }
    }
    
    /// Spacing between the last label and the bottom edge of the banner
    private let bottomSpacing: CGFloat = 10.0
    
    /// Spacing between title and subtitle
    private let innerSpacing: CGFloat = 2.5
    
    /// The bottom most label of the notification if a subtitle is provided
    public private(set) var subtitleLabel: UILabel?
    
    /// The view that is presented on the left side of the notification
    private var leftView: UIView?
    
    /// The view that is presented on the right side of the notification
    private var rightView: UIView?
    
    private let iconSize: CGFloat = 24.0
    
    public init(title: String,
                subtitle: String? = nil,
                leftView: UIView? = nil,
                rightView: UIView? = nil,
                style: BannerStyle = .info,
                colors: BannerColorsProtocol? = nil) {
        
        self.leftView = leftView
        self.rightView = rightView
        
        super.init(style: style, colors: colors)
        
        let labelsView = UIView()
        contentView.addSubview(labelsView)
        
        if let leftView = leftView {
            contentView.addSubview(leftView)
            
            leftView.snp.makeConstraints({ (make) in
                make.size.equalTo(iconSize)
                make.centerY.equalTo(labelsView)
                make.left.equalToSuperview().offset(padding)
            })
        }
        
        if let rightView = rightView {
            contentView.addSubview(rightView)
            
            rightView.snp.makeConstraints({ (make) in
                make.size.equalTo(iconSize)
                make.centerY.equalTo(labelsView)
                make.right.equalToSuperview().offset(-padding)
            })
        }
        
        titleLabel = UILabel()
        titleLabel!.font = UIFont.systemFont(ofSize: 17.5, weight: UIFont.Weight.bold)
        titleLabel!.textColor = .white
        titleLabel!.text = title
        titleLabel!.numberOfLines = 0
        titleLabel!.setContentHuggingPriority(.required, for: .vertical)
        labelsView.addSubview(titleLabel!)
        
        titleLabel!.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        if let subtitle = subtitle {
            subtitleLabel = UILabel()
            subtitleLabel!.font = UIFont.systemFont(ofSize: 15.0)
            subtitleLabel!.numberOfLines = 0
            subtitleLabel!.textColor = .white
            subtitleLabel!.text = subtitle
            labelsView.addSubview(subtitleLabel!)
            
            subtitleLabel!.snp.makeConstraints { (make) in
                make.top.equalTo(titleLabel!.snp.bottom).offset(2.5)
                make.left.equalTo(titleLabel!)
                make.right.equalTo(titleLabel!)
                make.bottom.equalToSuperview()
            }
        }
        
        labelsView.snp.makeConstraints { (make) in
            if let leftView = leftView {
                make.left.equalTo(leftView.snp.right).offset(padding)
            } else {
                if #available(iOS 11.0, *) {
                    make.left.equalTo(safeAreaLayoutGuide).offset(padding)
                } else {
                    make.left.equalToSuperview().offset(padding)
                }
                
            }
            
            if let rightView = rightView {
                make.right.equalTo(rightView.snp.left).offset(-padding)
            } else {
                if #available(iOS 11.0, *) {
                    make.right.equalTo(safeAreaLayoutGuide).offset(-padding)
                } else {
                    make.right.equalToSuperview().offset(-padding)
                }
            }
            
            make.bottom.equalToSuperview().offset(-bottomSpacing)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
