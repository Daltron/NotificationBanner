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

public class BaseNotificationBanner: UIView {
    
    // The height of the banner when it is presented
    public var bannerHeight: CGFloat = 64.0
    
    // The topmost label of the notification if a custom view is not desired
    public internal(set) var titleLabel: MarqueeLabel?
    
    // The time before the notificaiton is automatically dismissed
    public var duration: TimeInterval = 5.0 {
        didSet {
            updateMarqueeLabelsDurations()
        }
    }
    
    // If true, notification will dismissed when tapped
    public var dismissOnTap: Bool = true
    
    // Closure that will be executed if the notification banner is tapped
    public var onTap: (() -> Void)?

    // The view that the notification layout is presented on. The constraints/frame of this should not be changed
    internal var contentView: UIView!
    
    // The default padding between edges and views
    internal var padding: CGFloat = 15.0
    
    // Used by the banner queue to determine wether a notification banner was placed in front of it in the queue
    var isSuspended: Bool = false
    
    // Responsible for positioning and auto managing notification banners
    private let bannerQueue: NotificationBannerQueue = NotificationBannerQueue.sharedInstance
    
    // The main window of the application which banner views are placed on
    private let APP_WINDOW: UIWindow = UIApplication.shared.delegate!.window!!
    
    // A view that helps the spring animation look nice when the banner appears
    private var spacerView: UIView!
    
    public override var backgroundColor: UIColor? {
        get {
            return contentView.backgroundColor
        } set {
            contentView.backgroundColor = newValue
            spacerView.backgroundColor = newValue
        }
    }
    
    init(style: BannerStyle) {
        super.init(frame: .zero)
        
        spacerView = UIView()
        addSubview(spacerView)
        
        spacerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(10)
        }
        
        contentView = UIView()
        addSubview(contentView)
        
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(spacerView.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        backgroundColor = color(for: style)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onOrientationChanged), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    public func dismiss() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(dismiss), object: nil)
        UIView.animate(withDuration: 0.5, animations: {
            self.frame = CGRect(x: 0, y: -self.frame.height, width: self.frame.width, height: self.frame.height)
        }) { (completed) in
            self.removeFromSuperview()
            self.bannerQueue.showNext(onEmpty: {
                self.APP_WINDOW.windowLevel = UIWindowLevelNormal
            })
        }
    }
    
    public func show(queuePosition: QueuePosition = .back) {
        show(placeOnQueue: true, queuePosition: queuePosition)
    }
    
    func show(placeOnQueue: Bool, queuePosition: QueuePosition = .back) {
        if placeOnQueue {
            bannerQueue.addBanner(self, queuePosition: queuePosition)
        } else {
            self.frame = CGRect(x: 0, y: -bannerHeight, width: APP_WINDOW.frame.width, height: bannerHeight)
            APP_WINDOW.addSubview(self)
            APP_WINDOW.windowLevel = UIWindowLevelStatusBar + 1
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveLinear, animations: {
                self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            }) { (completed) in
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onTapGestureRecognizer))
                self.addGestureRecognizer(tapGestureRecognizer)
                
                // We don't want to add the selector if another banner was queued in front of it before it finished animating
                if !self.isSuspended {
                    self.perform(#selector(self.dismiss), with: nil, afterDelay: self.duration)
                }
            }
        }
    }
    
    func suspend() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(dismiss), object: nil)
        isSuspended = true
    }
    
    func resume() {
        self.perform(#selector(dismiss), with: nil, afterDelay: self.duration)
        isSuspended = false
    }
    
    private dynamic func onOrientationChanged() {
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: APP_WINDOW.frame.width, height: self.frame.height)
    }
    
    private dynamic func onTapGestureRecognizer() {
        if dismissOnTap {
            dismiss()
        }
        
        onTap?()
    }
    
    private func color(for type: BannerStyle) -> UIColor {
        return type.color
    }

    internal func updateMarqueeLabelsDurations() {
        titleLabel?.speed = .duration(CGFloat(duration - 3))
    }
}

