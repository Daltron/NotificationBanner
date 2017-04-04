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
import MarqueeLabel

public class StatusBarNotificationBanner: BaseNotificationBanner {
    
    override init(config: BannerConfiguration) {
        super.init(config: config)
        self.config.bannerHeight = 20.0
        updateMarqueeLabelsDurations()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public convenience init(title: String, style: BannerStyle = .info) {
        self.init(config: style.getConfiguration(withTitle: title))
    }
    
    public convenience init(attributedTitle: NSAttributedString, style: BannerStyle = .info) {
        self.init(config: style.getConfiguration(withAttributedTitle: attributedTitle))
    }
    
    override func createTitleLabel() -> MarqueeLabel {
        let label = MarqueeLabel()
        label.animationDelay = 2
        label.type = .leftRight
        label.font = UIFont.systemFont(ofSize: 12.5, weight: UIFontWeightBold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }
    
    override func setUp(withConfig: BannerConfiguration) {
        super.setUp(withConfig: config)
        titleLabel.text = config.title
        if let title = config.attributedTitle {
            titleLabel.attributedText = title
        }
    }
    
    override func addViews() {
        super.addViews()
        addSubview(titleLabel)
    }

    override public func updateConstraints() {
        super.updateConstraints()
        
        titleLabel.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview()
        }
        
    }
}
