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
import MarqueeLabel

public class NotificationBanner: BaseNotificationBanner {
    lazy public private(set) var labelsView: UIView = {
       return UIView()
    }()
    
    // The bottom most label of the notification if a subtitle is provided
    lazy public private(set) var subtitleLabel: MarqueeLabel? = {
        return self.createSubtitleLabel()
    }()
    
    public private(set) var customView: UIView? = nil
    
    public private(set) var leftView: UIView? = nil
    public private(set) var rightView: UIView? = nil
    
    convenience init(title: String, subtitle: String? = nil, leftView: UIView? = nil, rightView: UIView? = nil, style: BannerStyle = .info) {
        self.init(config: style.getConfiguration(withTitle: title, subtitle: subtitle, leftView: leftView, rightView: rightView))
    }
    
    override init(config: BannerConfiguration) {
        super.init(config: config)
        updateMarqueeLabelsDurations()
    }
    
    public init(customView: UIView) {
        super.init(config: BannerStyle.none.getConfiguration(withCustomView: customView))
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func onInit(withConfig: BannerConfiguration) {
        super.onInit(withConfig: config)
        if let leftView = config.leftView {
            self.leftView = leftView
        }
        if let rightView = config.rightView {
            self.rightView = rightView
        }
        titleLabel.text = config.title
        if let title = config.attributedTitle {
            titleLabel.attributedText = title
        }
        
        if let subtitle = config.subtitle {
            subtitleLabel?.text = subtitle
        } else if let subtitle = config.attributedSubtitle {
            subtitleLabel?.attributedText = subtitle
        }
        
        if let customView = config.customView {
            self.customView = customView
        }
    }
    
    internal override func updateMarqueeLabelsDurations() {
        super.updateMarqueeLabelsDurations()
        subtitleLabel?.speed = .duration(CGFloat(duration - 3))
    }
    
    override func addViews() {
        super.addViews()
        contentView.addSubview(labelsView)
        labelsView.addSubview(titleLabel)
        if let subtitleLabel = subtitleLabel {
            labelsView.addSubview(subtitleLabel)
        }
        if let leftView = leftView {
            contentView.addSubview(leftView)
        }
        if let rightView = rightView {
            contentView.addSubview(rightView)
        }
        if let customView = customView {
            contentView.addSubview(customView)
        }
    }
    
    override func createTitleLabel() -> MarqueeLabel {
        let label = MarqueeLabel()
        label.type = .leftRight
        label.font = UIFont.systemFont(ofSize: 17.5, weight: UIFontWeightBold)
        label.textColor = .white
        return label
    }
    
    func createSubtitleLabel() -> MarqueeLabel? {
        if self.config.subtitle == nil && self.config.attributedSubtitle == nil {
            return nil
        }
        let label = MarqueeLabel()
        label.type = .leftRight
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.numberOfLines = 1
        label.textColor = .white
        return label
    }
    
    override public func updateConstraints() {
        super.updateConstraints()
        
        titleLabel.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            if let _ = config.subtitle {
                titleLabel.numberOfLines = 1
            } else {
                titleLabel.numberOfLines = 2
            }
        }
        
        subtitleLabel?.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(2.5)
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
        }
        
        labelsView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            
            if let leftView = config.leftView {
                make.left.equalTo(leftView.snp.right).offset(padding)
            } else {
                make.left.equalToSuperview().offset(padding)
            }
            
            if let rightView = config.rightView {
                make.right.equalTo(rightView.snp.left).offset(-padding)
            } else {
                make.right.equalToSuperview().offset(-padding)
            }
            
            if let subtitleLabel = subtitleLabel {
                make.bottom.equalTo(subtitleLabel)
            } else {
                make.bottom.equalTo(titleLabel)
            }
        }
        
        leftView?.snp.remakeConstraints({ (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(self.leftView!.snp.height)
        })
        
        rightView?.snp.remakeConstraints({ (make) in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(self.rightView!.snp.height)
        })
        
        customView?.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
    }
}
