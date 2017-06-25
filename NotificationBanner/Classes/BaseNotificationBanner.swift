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

#if CARTHAGE_CONFIG
    import MarqueeLabelSwift
#else
    import MarqueeLabel
#endif

public protocol NotificationBannerDelegate: class {
    func notificationBannerWillAppear(_ banner: BaseNotificationBanner)
    func notificationBannerDidAppear(_ banner: BaseNotificationBanner)
    func notificationBannerWillDisappear(_ banner: BaseNotificationBanner)
    func notificationBannerDidDisappear(_ banner: BaseNotificationBanner)
}

public class BaseNotificationBanner: UIView {
    
    /// The delegate of the notification banner
    public weak var delegate: NotificationBannerDelegate?
    
    /// The height of the banner when it is presented
    public var bannerHeight: CGFloat = 64.0
    
    /// The topmost label of the notification if a custom view is not desired
    public internal(set) var titleLabel: MarqueeLabel?
    
    /// The time before the notificaiton is automatically dismissed
    public var duration: TimeInterval = 5.0 {
        didSet {
            updateMarqueeLabelsDurations()
        }
    }
    
    /// If false, the banner will not be dismissed until the developer programatically dismisses it
    public var autoDismiss: Bool = true {
        didSet {
            if !autoDismiss {
                dismissOnTap = false
                dismissOnSwipeUp = false
            }
        }
    }
    
    /// The type of haptic to generate when a banner is displayed
    public var haptic: BannerHaptic = .heavy
    
    /// If true, notification will dismissed when tapped
    public var dismissOnTap: Bool = true
    
    /// If true, notification will dismissed when swiped up
    public var dismissOnSwipeUp: Bool = true
    
    /// Closure that will be executed if the notification banner is tapped
    public var onTap: (() -> Void)?
    
    /// Closure that will be executed if the notification banner is swiped up
    public var onSwipeUp: (() -> Void)?
    
    /// Wether or not the notification banner is currently being displayed
    public private(set) var isDisplaying: Bool = false

    /// The view that the notification layout is presented on. The constraints/frame of this should not be changed
    internal var contentView: UIView!
    
    /// The default padding between edges and views
    internal var padding: CGFloat = 15.0
    
    /// Used by the banner queue to determine wether a notification banner was placed in front of it in the queue
    var isSuspended: Bool = false
    
    /// Responsible for positioning and auto managing notification banners
    private let bannerQueue: NotificationBannerQueue = NotificationBannerQueue.default
    
    /// The main window of the application which banner views are placed on
    private let appWindow: UIWindow = UIApplication.shared.delegate!.window!!
    
    /// A view that helps the spring animation look nice when the banner appears
    private var spacerView: UIView!
    
    /// The view controller to display the banner on. This is useful if you are wanting to display a banner underneath a navigation bar
    private weak var parentViewController: UIViewController?
    
    /// The position the notification banner should slide in from
    private(set) var bannerPosition: BannerPosition!
    
    /// Object that stores the start and end frames for the notification banner based on the provided banner position
    private var bannerPositionFrame: BannerPositionFrame!
    
    public override var backgroundColor: UIColor? {
        get {
            return contentView.backgroundColor
        } set {
            contentView.backgroundColor = newValue
            spacerView.backgroundColor = newValue
        }
    }
    
    init(style: BannerStyle, colors: BannerColorsProtocol? = nil) {
        super.init(frame: .zero)
        
        spacerView = UIView()
        addSubview(spacerView)
        
        contentView = UIView()
        addSubview(contentView)
        
        if let colors = colors {
            backgroundColor = colors.color(for: style)
        } else {
            backgroundColor = BannerColors().color(for: style)
        }
        
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeUpGestureRecognizer))
        swipeUpGesture.direction = .up
        addGestureRecognizer(swipeUpGesture)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onOrientationChanged),
                                               name: NSNotification.Name.UIDeviceOrientationDidChange,
                                               object: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIDeviceOrientationDidChange,
                                                  object: nil)
    }
    
    /**
        Creates the proper banner constraints based on the desired banner position
     */
    
    private func createBannerConstraints(for bannerPosition: BannerPosition) {
        
        spacerView.snp.remakeConstraints { (make) in
            if bannerPosition == .top {
                make.top.equalToSuperview().offset(-10)
            } else {
                make.bottom.equalToSuperview().offset(10)
            }
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(10)
        }
        
        contentView.snp.remakeConstraints { (make) in
            if bannerPosition == .top {
                make.top.equalTo(spacerView.snp.bottom)
                make.bottom.equalToSuperview()
            } else {
                make.top.equalToSuperview()
                make.bottom.equalTo(spacerView.snp.top)
            }
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }

    }
    
    /**
        Dismisses the NotificationBanner and shows the next one if there is one to show on the queue
    */
    public func dismiss() {
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(dismiss),
                                               object: nil)
        delegate?.notificationBannerWillDisappear(self)
        UIView.animate(withDuration: 0.5, animations: {
            self.frame = self.bannerPositionFrame.startFrame
        }) { (completed) in
            self.delegate?.notificationBannerDidDisappear(self)
            self.removeFromSuperview()
            self.isDisplaying = false
            self.bannerQueue.showNext(callback: { (isEmpty) in
                if isEmpty || self.statusBarShouldBeShown() {
                    self.appWindow.windowLevel = UIWindowLevelNormal
                }
            })
        }
    }
    
    /**
        Places a NotificationBanner on the queue and shows it if its the first one in the queue
        - parameter queuePosition: The position to show the notification banner. If the position is .front, the
        banner will be displayed immediately
        - parameter viewController: The view controller to display the notifification banner on. If nil, it will
        be placed on the main app window
        - parameter bannerPosition: The position the notification banner should slide in from
    */
    public func show(queuePosition: QueuePosition = .back,
                     bannerPosition: BannerPosition = .top,
                     on viewController: UIViewController? = nil) {
        parentViewController = viewController
        show(placeOnQueue: true, queuePosition: queuePosition, bannerPosition: bannerPosition)
    }
    
    /**
        Places a NotificationBanner on the queue and shows it if its the first one in the queue
        - parameter placeOnQueue: If false, banner will not be placed on the queue and will be showed/resumed immediately
        - parameter queuePosition: The position to show the notification banner. If the position is .front, the
        banner will be displayed immediately
        - parameter bannerPosition: The position the notification banner should slide in from
    */
    func show(placeOnQueue: Bool,
              queuePosition: QueuePosition = .back,
              bannerPosition: BannerPosition = .top) {
        
        if bannerPositionFrame == nil {
            self.bannerPosition = bannerPosition
            createBannerConstraints(for: bannerPosition)
            bannerPositionFrame = BannerPositionFrame(bannerPosition: bannerPosition,
                                                      bannerWidth: appWindow.frame.width,
                                                      bannerHeight: bannerHeight,
                                                      maxY: maximumYPosition())
        }
        
        if placeOnQueue {
            bannerQueue.addBanner(self, queuePosition: queuePosition)
        } else {
            self.frame = bannerPositionFrame.startFrame
            
            if let parentViewController = parentViewController {
                parentViewController.view.addSubview(self)
                if statusBarShouldBeShown() {
                    appWindow.windowLevel = UIWindowLevelNormal
                }
            } else {
                appWindow.addSubview(self)
                if statusBarShouldBeShown() && !(parentViewController == nil && bannerPosition == .top) {
                    appWindow.windowLevel = UIWindowLevelNormal
                } else {
                    appWindow.windowLevel = UIWindowLevelStatusBar + 1
                }
            }
            delegate?.notificationBannerWillAppear(self)
            UIView.animate(withDuration: 0.5,
                           delay: 0.0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 1,
                           options: .curveLinear,
                           animations: {
                            BannerHapticGenerator.generate(self.haptic)
                            self.frame = self.bannerPositionFrame.endFrame
            }) { (completed) in
                self.delegate?.notificationBannerDidAppear(self)
                self.isDisplaying = true
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onTapGestureRecognizer))
                self.addGestureRecognizer(tapGestureRecognizer)
                
                /* We don't want to add the selector if another banner was queued in front of it
                   before it finished animating or if it is meant to be shown infinitely
                */
                if !self.isSuspended && self.autoDismiss {
                    self.perform(#selector(self.dismiss), with: nil, afterDelay: self.duration)
                }
            }
        }
    }
    
    /**
        Suspends a notification banner so it will not be dismissed. This happens because a new notification banner was placed in front of it on the queue.
    */
    func suspend() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(dismiss), object: nil)
        isSuspended = true
        isDisplaying = false
    }
    
    /**
        Resumes a notification banner immediately.
    */
    func resume() {
        if autoDismiss {
            self.perform(#selector(dismiss), with: nil, afterDelay: self.duration)
            isSuspended = false
            isDisplaying = true
        }
    }
    
    /**
        Changes the frame of the notificaiton banner when the orientation of the device changes
    */
    private dynamic func onOrientationChanged() {
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: appWindow.frame.width, height: self.frame.height)
    }
    
    /**
        Called when a notification banner is tapped
    */
    private dynamic func onTapGestureRecognizer() {
        if dismissOnTap {
            dismiss()
        }
        
        onTap?()
    }
    
    /**
        Called when a notification banner is swiped up
    */
    private dynamic func onSwipeUpGestureRecognizer() {
        if dismissOnSwipeUp {
            dismiss()
        }
        
        onSwipeUp?()
    }
    
    
    /**
        Determines wether or not the status bar should be shown when displaying a banner underneath
        the navigation bar
     */
    private func statusBarShouldBeShown() -> Bool {
        
        for banner in bannerQueue.banners {
            if (banner.parentViewController == nil && banner.bannerPosition == .top) {
                return false
            }
        }
        
        return true
    }
    
    /** 
        Calculates the maximum `y` position that a notification banner can slide in from
    */
 
    private func maximumYPosition() -> CGFloat {
        if let parentViewController = parentViewController {
            return parentViewController.view.frame.height
        } else {
            return appWindow.frame.height
        }
    }

    /**
        Updates the scrolling marquee label duration
    */
    internal func updateMarqueeLabelsDurations() {
        titleLabel?.speed = .duration(CGFloat(duration - 3))
    }
    
}

