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

@objcMembers
public class BaseNotificationBanner: UIView {
    
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
    
    /// The delegate of the notification banner
    public weak var delegate: NotificationBannerDelegate?

    /// The height of the banner when it is presented
    public var bannerHeight: CGFloat {
        get {
            if let customBannerHeight = customBannerHeight {
                return customBannerHeight
            } else {
                return shouldAdjustForNotchFeaturedIphone() ? 88.0 : 64.0
            }
        } set {
            customBannerHeight = newValue
        }
    }
    
    /// The topmost label of the notification if a custom view is not desired
    public internal(set) var titleLabel: UILabel?
    
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
    
    /// Responsible for positioning and auto managing notification banners
    public var bannerQueue: NotificationBannerQueue = NotificationBannerQueue.default
    
    /// Banner dimiss animation duration
    public var dismissDuration: TimeInterval = 0.5
    
    /// Wether or not the notification banner is currently being displayed
    public private(set) var isDisplaying: Bool = false

    /// The view that the notification layout is presented on. The constraints/frame of this should not be changed
    internal var contentView: UIView!
    
    /// A view that helps the spring animation look nice when the banner appears
    internal var spacerView: UIView!
    
    /// The default offset for spacerView top or bottom
    internal var spacerViewDefaultOffset: CGFloat = 10.0

    /// The default padding between edges and views
    internal var padding: CGFloat = 15.0
    
    /// The view controller to display the banner on. This is useful if you are wanting to display a banner underneath a navigation bar
    internal weak var parentViewController: UIViewController?
    
    /// If this is not nil, then this height will be used instead of the auto calculated height
    internal var customBannerHeight: CGFloat?
    
    /// Used by the banner queue to determine wether a notification banner was placed in front of it in the queue
    var isSuspended: Bool = false
    
    /// The main window of the application which banner views are placed on
    private let appWindow: UIWindow = UIApplication.shared.delegate!.window!!
    
    /// The position the notification banner should slide in from
    private(set) var bannerPosition: BannerPosition!
    
    /// The notification banner sides edges insets from superview. If presented - spacerView color will be transparent
    internal(set) var bannerEdgeInsets: UIEdgeInsets? = nil {
        didSet {
            if bannerEdgeInsets != nil {
                spacerView.backgroundColor = .clear
            }
        }
    }

    /// Object that stores the start and end frames for the notification banner based on the provided banner position
    internal var bannerPositionFrame: BannerPositionFrame!
    
    /// The user info that gets passed to each notification
    private var notificationUserInfo: [String: BaseNotificationBanner] {
        return [BaseNotificationBanner.BannerObjectKey: self]
    }
    
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
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIDevice.orientationDidChangeNotification,
                                                  object: nil)
    }
    
    /**
        Creates the proper banner constraints based on the desired banner position
     */
    private func createBannerConstraints(for bannerPosition: BannerPosition) {
        
        spacerView.snp.remakeConstraints { (make) in
            if bannerPosition == .top {
                make.top.equalToSuperview().offset(-spacerViewDefaultOffset)
            } else {
                make.bottom.equalToSuperview().offset(spacerViewDefaultOffset)
            }
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            updateSpacerViewHeight(make: make)
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
         Updates the spacer view height. Specifically used for orientation changes.
     */
    private func updateSpacerViewHeight(make: ConstraintMaker? = nil) {
        let finalHeight = spacerViewHeight()
        if let make = make {
            make.height.equalTo(finalHeight)
        } else {
            spacerView.snp.updateConstraints({ (make) in
                make.height.equalTo(finalHeight)
            })
        }
    }
    
    internal func spacerViewHeight() -> CGFloat {
        return NotificationBannerUtilities.isNotchFeaturedIPhone()
            && UIApplication.shared.statusBarOrientation.isPortrait
            && (parentViewController?.navigationController?.isNavigationBarHidden ?? true) ? 40.0 : 10.0
    }
    
    /**
        Dismisses the NotificationBanner and shows the next one if there is one to show on the queue
    */
    @objc public func dismiss() {
        
        guard isDisplaying else {
            return
        }
        
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(dismiss),
                                               object: nil)
        
        NotificationCenter.default.post(name: BaseNotificationBanner.BannerWillDisappear, object: self, userInfo: notificationUserInfo)
        delegate?.notificationBannerWillDisappear(self)
        
        UIView.animate(withDuration: dismissDuration, animations: {
            self.frame = self.bannerPositionFrame.startFrame
        }) { (completed) in
            self.removeFromSuperview()
            self.isDisplaying = false
            
            NotificationCenter.default.post(name: BaseNotificationBanner.BannerDidDisappear, object: self, userInfo: self.notificationUserInfo)
            self.delegate?.notificationBannerDidDisappear(self)
            
            self.bannerQueue.showNext(callback: { (isEmpty) in
                if isEmpty || self.statusBarShouldBeShown() {
                    self.appWindow.windowLevel = UIWindow.Level.normal
                }
            })
        }
    }
    
    /**
        Removes the NotificationBanner from the queue if not displaying
     */
    public func remove() {
        
        guard !isDisplaying else {
            return
        }
        
        bannerQueue.removeBanner(self)
    }
    
    /**
        Places a NotificationBanner on the queue and shows it if its the first one in the queue
        - parameter queuePosition: The position to show the notification banner. If the position is .front, the
        banner will be displayed immediately
        - parameter bannerPosition: The position the notification banner should slide in from
        - parameter queue: The queue to display the notification banner on. It is up to the developer
        to manage multiple banner queues and prevent any conflicts that may occur.
        - parameter viewController: The view controller to display the notifification banner on. If nil, it will
        be placed on the main app window
    */
    public func show(queuePosition: QueuePosition = .back,
                     bannerPosition: BannerPosition = .top,
                     queue: NotificationBannerQueue = NotificationBannerQueue.default,
                     on viewController: UIViewController? = nil) {
        parentViewController = viewController
        bannerQueue = queue
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
        
        guard !isDisplaying else {
            return
        }
        
        if bannerPositionFrame == nil {
            self.bannerPosition = bannerPosition
            createBannerConstraints(for: bannerPosition)
            bannerPositionFrame = BannerPositionFrame(bannerPosition: bannerPosition,
                                                      bannerWidth: appWindow.frame.width,
                                                      bannerHeight: bannerHeight,
                                                      maxY: maximumYPosition(),
                                                      edgeInsets: bannerEdgeInsets)
        }
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIDevice.orientationDidChangeNotification,
                                                  object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onOrientationChanged),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
        
        if placeOnQueue {
            bannerQueue.addBanner(self, queuePosition: queuePosition)
        } else {
            self.frame = bannerPositionFrame.startFrame
            
            if let parentViewController = parentViewController {
                parentViewController.view.addSubview(self)
                if statusBarShouldBeShown() {
                    appWindow.windowLevel = UIWindow.Level.normal
                }
            } else {
                appWindow.addSubview(self)
                if statusBarShouldBeShown() && !(parentViewController == nil && bannerPosition == .top) {
                    appWindow.windowLevel = UIWindow.Level.normal
                } else {
                    appWindow.windowLevel = UIWindow.Level.statusBar + 1
                }
            }
            
            NotificationCenter.default.post(name: BaseNotificationBanner.BannerWillAppear, object: self, userInfo: notificationUserInfo)
            delegate?.notificationBannerWillAppear(self)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onTapGestureRecognizer))
            self.addGestureRecognizer(tapGestureRecognizer)
            
            self.isDisplaying = true
            
            UIView.animate(withDuration: 0.5,
                           delay: 0.0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 1,
                           options: [.curveLinear,.allowUserInteraction],
                           animations: {
                            BannerHapticGenerator.generate(self.haptic)
                            self.frame = self.bannerPositionFrame.endFrame
            }) { (completed) in
                
                NotificationCenter.default.post(name: BaseNotificationBanner.BannerDidAppear, object: self, userInfo: self.notificationUserInfo)
                self.delegate?.notificationBannerDidAppear(self)

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
        if autoDismiss {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(dismiss), object: nil)
            isSuspended = true
            isDisplaying = false
        }
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
        Resets a notification banner's elapsed duration to zero.
    */
    public func resetDuration() {
        if autoDismiss {
             NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(dismiss), object: nil)
             self.perform(#selector(dismiss), with: nil, afterDelay: self.duration)
        }
    }
    
    /**
        Update banner height, it's necessary after banner labels font update
     */
    internal func updateBannerHeight() {
        onOrientationChanged()
    }
    
    /**
        Changes the frame of the notification banner when the orientation of the device changes
    */
    @objc private dynamic func onOrientationChanged() {
        updateSpacerViewHeight()
        
        let edgeInsets = bannerEdgeInsets ?? .zero

        let newY = (bannerPosition == .top) ? (frame.origin.y) : (appWindow.frame.height - bannerHeight + edgeInsets.top - edgeInsets.bottom)
        frame = CGRect(x: frame.origin.x,
                       y: newY,
                       width: appWindow.frame.width - edgeInsets.left - edgeInsets.right,
                       height: bannerHeight)
    
        bannerPositionFrame = BannerPositionFrame(bannerPosition: bannerPosition,
                                                  bannerWidth: appWindow.frame.width,
                                                  bannerHeight: bannerHeight,
                                                  maxY: maximumYPosition(),
                                                  edgeInsets: bannerEdgeInsets)
    }
    
    /**
        Called when a notification banner is tapped
    */
    @objc private dynamic func onTapGestureRecognizer() {
        if dismissOnTap {
            dismiss()
        }
        
        onTap?()
    }
    
    /**
        Called when a notification banner is swiped up
    */
    @objc private dynamic func onSwipeUpGestureRecognizer() {
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
         Determines wether or not we should adjust the banner for notch featured iPhone
     */
    
    internal func shouldAdjustForNotchFeaturedIphone() -> Bool {
        return NotificationBannerUtilities.isNotchFeaturedIPhone()
            && UIApplication.shared.statusBarOrientation.isPortrait
            && (self.parentViewController?.navigationController?.isNavigationBarHidden ?? true)
    }
    /**
        Updates the scrolling marquee label duration
    */
    internal func updateMarqueeLabelsDurations() {
        (titleLabel as? MarqueeLabel)?.speed = .duration(CGFloat(duration - 3))
    }
}

