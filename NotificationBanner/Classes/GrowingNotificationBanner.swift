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
    
    public enum IconPosition {
        case top
        case center
    }
    
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
                
                let titleHeight = ceil(titleLabel?.sizeThatFits(
                    CGSize(width: boundingWidth,
                           height: .greatestFiniteMagnitude)).height ?? 0.0)
                
                let subtitleHeight = ceil(subtitleLabel?.sizeThatFits(
                    CGSize(width: boundingWidth,
                           height: .greatestFiniteMagnitude)).height ?? 0.0)
                
                let topOffset: CGFloat = shouldAdjustForNotchFeaturedIphone() ? 44.0 : verticalSpacing
                let minHeight: CGFloat = shouldAdjustForNotchFeaturedIphone() ? 88.0 : 64.0
                
                var actualBannerHeight = topOffset + titleHeight + subtitleHeight + verticalSpacing
                
                if !subtitleHeight.isZero && !titleHeight.isZero {
                    actualBannerHeight += innerSpacing
                }
                
                return max(actualBannerHeight, minHeight)
            }
        } set {
            customBannerHeight = newValue
        }
    }
    
    /// Spacing between the last label and the bottom edge of the banner
    private let verticalSpacing: CGFloat = 14.0
    
    /// Spacing between title and subtitle
    private let innerSpacing: CGFloat = 2.5
    
    /// The bottom most label of the notification if a subtitle is provided
    public private(set) var subtitleLabel: UILabel?
    
    /// The view that is presented on the left side of the notification
    private var leftView: UIView?
    
    /// The view that is presented on the right side of the notification
    private var rightView: UIView?
    
    /// Square size for left/right view if set
    private let iconSize: CGFloat = 24.0
    
    /// Font used for the title label
    internal var titleFont: UIFont = UIFont.systemFont(ofSize: 17.5, weight: UIFont.Weight.bold)
    
    /// Font used for the subtitle label
    internal var subtitleFont: UIFont = UIFont.systemFont(ofSize: 15.0)
    
    public init(title: String? = nil,
                subtitle: String? = nil,
                leftView: UIView? = nil,
                rightView: UIView? = nil,
                style: BannerStyle = .info,
                colors: BannerColorsProtocol? = nil,
                iconPosition: IconPosition = .center) {
        
        self.leftView = leftView
        self.rightView = rightView
        
        super.init(style: style, colors: colors)
        
        let labelsView = UIStackView()
        labelsView.axis = .vertical
        labelsView.spacing = innerSpacing
        
        let outerStackView = UIStackView()
        outerStackView.spacing = padding
        
        switch iconPosition {
        case .top:
            outerStackView.alignment = .top
        case .center:
            outerStackView.alignment = .center
        }
        
        if let leftView = leftView {
            outerStackView.addArrangedSubview(leftView)
            
            leftView.snp.makeConstraints { $0.size.equalTo(iconSize) }
        }
        
        outerStackView.addArrangedSubview(labelsView)
        
        if let title = title {
            titleLabel = UILabel()
            titleLabel!.font = titleFont
            titleLabel!.numberOfLines = 0
            titleLabel!.textColor = .white
            titleLabel!.text = title
            titleLabel!.setContentHuggingPriority(.required, for: .vertical)
            labelsView.addArrangedSubview(titleLabel!)
        }
        
        if let subtitle = subtitle {
            subtitleLabel = UILabel()
            subtitleLabel!.font = subtitleFont
            subtitleLabel!.numberOfLines = 0
            subtitleLabel!.textColor = .white
            subtitleLabel!.text = subtitle
            if title == nil {
                subtitleLabel!.setContentHuggingPriority(.required, for: .vertical)
            }
            labelsView.addArrangedSubview(subtitleLabel!)
        }
        
        if let rightView = rightView {
            outerStackView.addArrangedSubview(rightView)
            
            rightView.snp.makeConstraints { $0.size.equalTo(iconSize) }
        }
        
        contentView.addSubview(outerStackView)
        outerStackView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.left.equalTo(safeAreaLayoutGuide).offset(padding)
                make.right.equalTo(safeAreaLayoutGuide).offset(-padding)
            } else {
                make.left.equalToSuperview().offset(padding)
                make.right.equalToSuperview().offset(-padding)
            }
            
            make.centerY.equalToSuperview()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension GrowingNotificationBanner {
    
    func applyStyling(cornerRadius: CGFloat? = nil,
                      titleFont: UIFont? = nil,
                      titleColor: UIColor? = nil,
                      titleTextAlign: NSTextAlignment? = nil,
                      subtitleFont: UIFont? = nil,
                      subtitleColor: UIColor? = nil,
                      subtitleTextAlign: NSTextAlignment? = nil) {
        
        if let cornerRadius = cornerRadius {
            contentView.layer.cornerRadius = cornerRadius
        }
        
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
        
        if titleFont != nil || subtitleFont != nil {
            updateBannerHeight()
        }
    }
    
}
