//
//  ViewController.swift
//  NotificationBanner
//
//  Created by Daltron on 03/18/2017.
//  Copyright (c) 2017 Daltron. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class ExampleViewController: UIViewController {
    
    private var exampleView: ExampleView!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        edgesForExtendedLayout = UIRectEdge()
        exampleView = ExampleView(delegate: self)
        view = exampleView
        title = "Notification Banner"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func selectedQueuePosition() -> QueuePosition {
        let selectedIndex = exampleView.queuePositionSegmentedControl.selectedSegmentIndex
        return selectedIndex == 0 ? .front : .back
    }
    
    internal func selectedBannerPosition() -> BannerPosition {
        let selectedIndex = exampleView.bannerPositionSegmentedControl.selectedSegmentIndex
        return selectedIndex == 0 ? .top : .bottom
    }

}

extension ExampleViewController: NotificationBannerDelegate {
    
    internal func notificationBannerWillAppear(_ banner: BaseNotificationBanner) {
        print("[NotificationBannerDelegate] Banner will appear")
    }
    
    internal func notificationBannerDidAppear(_ banner: BaseNotificationBanner) {
        print("[NotificationBannerDelegate] Banner did appear")
    }
    
    internal func notificationBannerWillDisappear(_ banner: BaseNotificationBanner) {
        print("[NotificationBannerDelegate] Banner will disappear")
    }
    
    internal func notificationBannerDidDisappear(_ banner: BaseNotificationBanner) {
        print("[NotificationBannerDelegate] Banner did disappear")
    }
}

extension ExampleViewController: ExampleViewDelegate {
    
    internal func basicNotificationCellSelected(at index: Int) {
        switch index {
        case 0:
            // Basic Success Notification
            let banner = NotificationBanner(title: "Basic Success Notification",
                                            subtitle: "Extremely Customizable!",
                                            style: .success)
            banner.delegate = self
            
            banner.onTap = {
                self.showAlert(title: "Banner Success Notification Tapped", message: "")
            }
            
            banner.onSwipeUp = {
                self.showAlert(title: "Basic Success Notification Swiped Up", message: "")
            }
            
            banner.show(queuePosition: selectedQueuePosition(), bannerPosition: selectedBannerPosition())
        case 1:
            // Basic Danger Notification
            let banner = NotificationBanner(title: "Basic Danger Notification",
                                            subtitle: "Extremely Customizable!",
                                            style: .danger)
            banner.delegate = self
            
            banner.onTap = {
                self.showAlert(title: "Basic Danger Notification Tapped", message: "")
            }
            
            banner.show(queuePosition: selectedQueuePosition(), bannerPosition: selectedBannerPosition())
        case 2:
            //Basic Info Notification
            let banner = NotificationBanner(title: "Basic Info Notification",
                                            subtitle: "Extremely Customizable!",
                                            style: .info)
            banner.delegate = self
            
            banner.onTap = {
                self.showAlert(title: "Basic Info Notification Tapped", message: "")
            }
            
            banner.show(queuePosition: selectedQueuePosition(), bannerPosition: selectedBannerPosition())
        case 3:
            // Basic Warning Notification
            let banner = NotificationBanner(title: "Basic Warning Notification",
                                            subtitle: "Extremely Customizable!",
                                            style: .warning)
            banner.delegate = self
            
            banner.onTap = {
                self.showAlert(title: "Banner Warning Notification Tapped", message: "")
            }
            
            banner.show(queuePosition: selectedQueuePosition(), bannerPosition: selectedBannerPosition())
        case 4:
            // Basic Warning Notification with Custom Color
            let banner = NotificationBanner(title: "Custom Warning Notification",
                                            subtitle: "Displayed Under/Over the Navigation/Tab Bar",
                                            style: .warning,
                                            colors: CustomBannerColors())
            banner.delegate = self
            
            banner.onTap = {
                self.showAlert(title: "Banner Notification Tapped", message: "")
            }
            
            banner.show(queuePosition: selectedQueuePosition(), bannerPosition: selectedBannerPosition(), on: self)
        case 5:
            // Basic Warning Notification with Custom Color
            let banner = NotificationBanner(title: "Basic Notification",
                                            subtitle: "Must Be Dismissed Manually",
                                            style: .customView)
            banner.delegate = self
            banner.backgroundColor = blockColor(at: IndexPath(row: 5, section: 0))
            banner.autoDismiss = false
                
            banner.onTap = {
                self.showAlert(title: "Banner Notification Tapped", message: "")
                banner.dismiss()
            }
            
            banner.onSwipeUp = {
                banner.dismiss()
            }
            
            banner.show(queuePosition: selectedQueuePosition(), bannerPosition: selectedBannerPosition())
        case 6:
            // Growing Notification
            let banner = GrowingNotificationBanner(
                title: "Growing Notification",
                subtitle: """
                This is a growing notification.
                Instead of using a scroll animation the view grows in height if needed.
                """,
                style: .success)
            
            banner.delegate = self
            
            banner.onTap = {
                self.showAlert(title: "Banner Success Notification Tapped", message: "")
            }
            
            banner.onSwipeUp = {
                self.showAlert(title: "Basic Success Notification Swiped Up", message: "")
            }

            banner.show(queuePosition: selectedQueuePosition(), bannerPosition: selectedBannerPosition())
        default:
            return
        }
    }
    
    internal func basicNotificationCellWithSideViewsSelected(at index: Int) {
        switch index {
        case 0:
            // Success Notification with Left View
            let leftView = UIImageView(image: #imageLiteral(resourceName: "success"))
            let banner = NotificationBanner(title: "Success Notification", subtitle: "This notification has a left view!", leftView: leftView, style: .success)
            banner.delegate = self

            banner.show(queuePosition: selectedQueuePosition(), bannerPosition: selectedBannerPosition())
        case 1:
            // Danger Notification with Right View
            let rightView = UIImageView(image: #imageLiteral(resourceName: "danger"))
            let banner = NotificationBanner(title: "Danger Notification", subtitle: "This notification has a right view!", rightView: rightView, style: .danger)
            banner.delegate = self
            banner.show(queuePosition: selectedQueuePosition(), bannerPosition: selectedBannerPosition())
        case 2:
            // Info Notification with Left and Right Views
            let leftView = UIImageView(image: #imageLiteral(resourceName: "info"))
            let rightView = UIImageView(image: #imageLiteral(resourceName: "right_chevron"))
            let banner = NotificationBanner(title: "Info Notification", subtitle: "This notification has two side views!", leftView: leftView, rightView: rightView, style: .info)
            banner.delegate = self
            banner.show(queuePosition: selectedQueuePosition(), bannerPosition: selectedBannerPosition())
        default:
            return
        }
    }
    
    internal func basicCustomNotificationCellSelected(at index: Int) {
        switch index {
        case 0:
            // Tarheels Completely Custom Notification
            let banner = NotificationBanner(customView: NorthCarolinaBannerView())
            banner.delegate = self
            banner.show(queuePosition: selectedQueuePosition(), bannerPosition: selectedBannerPosition())
        default:
            return
        }
    }
    
    internal func basicGrowingNotificationCellSelected(at index: Int) {
        switch index {
        case 0:
            let leftView = UIImageView(image: #imageLiteral(resourceName: "danger"))
            let banner = GrowingNotificationBanner(title: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", subtitle: "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", leftView: leftView, style: .success)
            banner.delegate = self
            banner.show(queuePosition: selectedQueuePosition(), bannerPosition: selectedBannerPosition())
        default:
            let leftView = UIImageView(image: #imageLiteral(resourceName: "danger"))
            let banner = GrowingNotificationBanner(title: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", subtitle: "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", leftView: leftView, style: .danger, sideViewSize: 48)
            banner.delegate = self
            banner.show(queuePosition: selectedQueuePosition(), bannerPosition: selectedBannerPosition())
        }
    }
    
    internal func basicFloatingNotificationCellSelected(at index: Int) {
        switch index {
        case 0:
            let banner = FloatingNotificationBanner(title: "Success Notification",
                                                    subtitle: "This type of banner floats and has the capability of growing to an infinite amount of lines. This one also has a shadow.",
                                                    style: .success)

            banner.delegate = self
            banner.show(queuePosition: selectedQueuePosition(),
                        bannerPosition: selectedBannerPosition(),
                        cornerRadius: 10,
                        shadowBlurRadius: 15)
        case 1:
            let banner = FloatingNotificationBanner(title: "Danger Notification",
                                                    subtitle: "This type of banner floats and has the capability of growing to an infinite amount of lines.",
                                                    style: .danger)
            banner.delegate = self
            banner.show(queuePosition: selectedQueuePosition(),
                        bannerPosition: selectedBannerPosition(),
                        cornerRadius: 10)
        case 2:
            let banner = FloatingNotificationBanner(title: "Info Notification",
                                                    subtitle: "With adjusted transparency!",
                                                    style: .info)
            banner.delegate = self
            banner.transparency = 0.75
            banner.show(queuePosition: selectedQueuePosition(),
                        bannerPosition: selectedBannerPosition(),
                        cornerRadius: 10)
        default:
            let banner = FloatingNotificationBanner(customView: NorthCarolinaBannerView())
            banner.delegate = self
            banner.transparency = 0.75
            banner.show(queuePosition: selectedQueuePosition(),
                        bannerPosition: selectedBannerPosition(),
                        cornerRadius: 10,
                        shadowBlurRadius: 15)
        }
    }
    
    internal func basicStatusBarNotificationCellSelected(at index: Int) {
        switch index {
        case 0:
            // Status Bar Success Notification
            let banner = StatusBarNotificationBanner(title: "Success Status Bar Notification", style: .success)
            banner.delegate = self
            banner.show(queuePosition: selectedQueuePosition(), bannerPosition: selectedBannerPosition())
        case 1:
            // Status Bar Danger Notification
            let banner = StatusBarNotificationBanner(title: "Danger Status Bar Notification", style: .danger)
            banner.delegate = self
            banner.show(queuePosition: selectedQueuePosition(), bannerPosition: selectedBannerPosition())
        case 2:
            // Status Bar Info Notification
            let banner = StatusBarNotificationBanner(title: "Info Status Bar Notification", style: .info)
            banner.delegate = self
            banner.show(queuePosition: selectedQueuePosition(), bannerPosition: selectedBannerPosition())
        case 3:
            // Status Bar Warning Notification
            let banner = StatusBarNotificationBanner(title: "Warning Status Bar Notification", style: .warning)
            banner.delegate = self
            banner.show(queuePosition: selectedQueuePosition(),
                        bannerPosition: selectedBannerPosition())
        case 4:
            // Status Bar Custom Warning Notification
            let banner = StatusBarNotificationBanner(title: "Warning Status Bar Notification Warning Status Bar Notification Displayed Under/Over the Navigation/Tab Bar",
                                                     style: .warning,
                                                     colors: CustomBannerColors())
            banner.delegate = self
            banner.show(queuePosition: selectedQueuePosition(),
                        bannerPosition: selectedBannerPosition(),
                        on: self)
        case 5:
            // Status Bar Attributed Title Notification
            let title = "Custom Status Bar Notification"
            let attributedTitle = NSMutableAttributedString(string: title)
            attributedTitle.addAttribute(NSAttributedString.Key.foregroundColor,
                                         value: UIColor.red,
                                         range: (title as NSString).range(of: "Custom"))
            attributedTitle.addAttribute(NSAttributedString.Key.foregroundColor,
                                         value: UIColor.cyan,
                                         range: (title as NSString).range(of: "Status"))
            attributedTitle.addAttribute(NSAttributedString.Key.foregroundColor,
                                         value: UIColor.green,
                                         range: (title as NSString).range(of: "Bar"))
            attributedTitle.addAttribute(NSAttributedString.Key.foregroundColor,
                                         value: UIColor.orange,
                                         range: (title as NSString).range(of: "Notification"))
            let banner = StatusBarNotificationBanner(attributedTitle: attributedTitle)
            banner.backgroundColor = UIColor(red: 0.54, green: 0.40, blue: 0.54, alpha: 1.00)
            banner.delegate = self
            banner.show(queuePosition: selectedQueuePosition(), bannerPosition: selectedBannerPosition())
        default:
            return
        }
    }
    
    internal func numberOfCells(for section: Int) -> Int {
        switch section {
        case 0:
            return 6
        case 1:
            return 4
        case 2:
            return 1
        case 3:
            return 2
        case 4:
            return 4
        case 5:
            return 6
        default:
            return 0
        }
    }
    
    internal func notificationBannerTitle(for section: Int) -> String {
        switch section {
        case 0:
            return "Basic Notification Banners"
        case 1:
            return "Notification Banners with Side Views"
        case 2:
            return "Notification Banner with Custom View"
        case 3:
            return "Growing Notification Banners"
        case 4:
            return "Floating Notification Banners"
        case 5:
            return "Status Bar Notifications"
        default:
            return ""
        }
    }
    
    internal func blockColor(at indexPath: IndexPath) -> UIColor {
        
        if indexPath == IndexPath(row: numberOfCells(for: indexPath.section) - 2, section: 0)
            || indexPath == IndexPath(row: numberOfCells(for: indexPath.section) - 2, section: 5) {
            return CustomBannerColors().color(for: .warning)
        }
        
        switch indexPath.row {
        case 0:
            return UIColor(red: 0.22, green: 0.80, blue: 0.46, alpha: 1.00)
        case 1:
            return UIColor(red: 0.90, green: 0.31, blue: 0.26, alpha: 1.00)
        case 2:
            return UIColor(red: 0.23, green: 0.60, blue: 0.85, alpha: 1.00)
        case 3:
            return UIColor(red: 1.00, green: 0.66, blue: 0.16, alpha: 1.00)
        case 6:
            return UIColor(red: 0.81, green: 0.55, blue: 0.44, alpha: 1.00)
        default:
            return UIColor(red: 0.54, green: 0.40, blue: 0.54, alpha: 1.00)
        }
    }
    
   internal func notificationTitles(at indexPath: IndexPath) -> (String, String?) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                return ("Basic Success Notification", nil)
            case 1:
                return ("Basic Danger Notification", nil)
            case 2:
                return ("Basic Info Notification", nil)
            case 3:
                return ("Basic Warning Notification", nil)
            case 4:
                return ("Custom Warning Notification", "Displayed Under/Over the Navigation/Tab Bar")
            case 5:
                return ("Basic Notification", "Must Be Dismissed Manually")
            case 6:
                return ("Growing Notification", "Notification height based on length of labels")
            default:
                return ("", nil)
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                return ("Success Notification", "With Left View")
            case 1:
                return ("Danger Notification", "With Right View")
            case 2:
                return ("Info Notification", "With Left and Right Views")
            case 3:
                return ("Growing Notification", "With Left View")
            default:
                return ("", nil)
            }
        } else if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                return ("Tarheels Notification", "Completely Custom")
            default:
                return ("", nil)
            }
            
        } else if indexPath.section == 3 {
            switch indexPath.row {
            case 0:
                return ("Success Notification", "With default side view size")
            case 1:
                return ("Danger Notification", "With custom side view size")
            default:
                return ("", nil)
            }
        } else if indexPath.section == 4 {
            switch indexPath.row {
            case 0:
                return ("Success Notification", "This type of banner can float and can have its cornerRadius property adjusted")
            case 1:
                return ("Danger Notification", "This type of banner can float and can have its cornerRadius property adjusted")
            case 2:
                return ("Info Notification", "With adjusted transparency!")
            case 3:
                return ("Tarheels Notification", "This type of banner can float and can have its cornerRadius property adjusted")
            default:
                return ("", nil)
            }
        } else if indexPath.section == 5 {
            switch indexPath.row {
            case 0:
                return ("Success Notification", nil)
            case 1:
                return ("Danger Notification", nil)
            case 2:
                return ("Info Notification", nil)
            case 3:
                return ("Warning Notification", nil)
            case 4:
                return ("Custom Warning Notification", "Displayed Under/Over the Navigation/Tab Bar")
            case 5:
                return ("Custom Notification", nil)
            default:
                return ("", nil)
            }
        }
        
        return ("", nil)
    }
    
    internal func notificationImage(at indexPath: IndexPath) -> UIImage? {
        if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                return #imageLiteral(resourceName: "unc_logo")
            default:
                return nil
            }
        } else if indexPath.section == 4 {
            switch indexPath.row {
            case 3:
                return #imageLiteral(resourceName: "unc_logo")
            default:
                return nil
            }
        }
        
        return nil
    }
    
    internal func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    internal func showAlertWithCallback(title: String,
                                        message: String,
                                        buttonText: String = "OK",
                                        callback: @escaping () -> Void  ) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: buttonText, style: .default) { (action) in
            callback()
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        return alert
    }
    
    internal func showAlertWithCallbackOkAction(title: String, message: String, buttonText: String = "OK", callback:  @escaping () -> Void  ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: buttonText, style: .default) { (action) in
            callback()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

