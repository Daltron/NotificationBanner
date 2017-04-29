//
//  ViewController.swift
//  NotificationBanner
//
//  Created by Daltron on 03/18/2017.
//  Copyright (c) 2017 Daltron. All rights reserved.
//

import UIKit
import NotificationBanner

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
    
    func selectedQueuePosition() -> QueuePosition {
        let selectedIndex = exampleView.segmentedControl.selectedSegmentIndex
        return selectedIndex == 0 ? .front : .back
    }

}

extension ExampleViewController : ExampleViewDelegate {
    
    func basicNotificationCellSelected(at index: Int) {
        switch index {
        case 0:
            // Basic Success Notification
            let banner = NotificationBanner(title: "Basic Success Notification",
                                            subtitle: "Extremely Customizable!",
                                            style: .success)

            banner.onTap = {
                self.showAlert(title: "Basic Success Notification Tapped")
            }
            
            banner.onSwipeUp = {
                self.showAlert(title: "Basic Success Notification Swiped Up")
            }
            
            banner.show(queuePosition: selectedQueuePosition())
        case 1:
            // Basic Danger Notification
            let banner = NotificationBanner(title: "Basic Danger Notification",
                                            subtitle: "Extremely Customizable!",
                                            style: .danger)
            banner.show(queuePosition: selectedQueuePosition())
        case 2:
            //Basic Info Notification
            let banner = NotificationBanner(title: "Basic Info Notification",
                                            subtitle: "Extremely Customizable!",
                                            style: .info)
            banner.show(queuePosition: selectedQueuePosition())
        case 3:
            // Basic Warning Notification
            let banner = NotificationBanner(title: "Basic Warning Notification",
                                            subtitle: "Extremely Customizable!",
                                            style: .warning)
            banner.show(queuePosition: selectedQueuePosition())
        case 4:
            // Basic Warning Notification with Custom Color
            let banner = NotificationBanner(title: "Basic Warning Notification",
                                            subtitle: "Custom Warning Color",
                                            style: .warning,
                                            colors: CustomBannerColors())
            banner.show(queuePosition: selectedQueuePosition())
        default:
            return
        }
    }
    
    func basicNotificationCellWithSideViewsSelected(at index: Int) {
        switch index {
        case 0:
            // Success Notification with Left View
            let leftView = UIImageView(image: #imageLiteral(resourceName: "success"))
            let banner = NotificationBanner(title: "Success Notification", subtitle: "This notification has a left view!", leftView: leftView, style: .success)
            banner.show(queuePosition: selectedQueuePosition())
        case 1:
            // Danger Notification with Right View
            let rightView = UIImageView(image: #imageLiteral(resourceName: "danger"))
            let banner = NotificationBanner(title: "Danger Notification", subtitle: "This notification has a right view!", rightView: rightView, style: .danger)
            banner.show(queuePosition: selectedQueuePosition())
        case 2:
            // Info Notification with Left and Right Views
            let leftView = UIImageView(image: #imageLiteral(resourceName: "info"))
            let rightView = UIImageView(image: #imageLiteral(resourceName: "right_chevron"))
            let banner = NotificationBanner(title: "Info Notification", subtitle: "This notification has two side views!", leftView: leftView, rightView: rightView, style: .info)
            banner.show(queuePosition: selectedQueuePosition())
        default:
            return
        }
    }
    
    func basicCustomNotificationCellSelected(at index: Int) {
        switch index {
        case 0:
            // Tarheels Completely Custom Notification
            let banner = NotificationBanner(customView: NorthCarolinaBannerView())
            banner.show(queuePosition: selectedQueuePosition())
        default:
            return
        }
    }
    
    func basicStatusBarNotificationCellSelected(at index: Int) {
        switch index {
        case 0:
            // Status Bar Success Notification
            let banner = StatusBarNotificationBanner(title: "Success Status Bar Notification", style: .success)
            banner.show(queuePosition: selectedQueuePosition())
        case 1:
            // Status Bar Danger Notification
            let banner = StatusBarNotificationBanner(title: "Danger Status Bar Notification", style: .danger)
            banner.show(queuePosition: selectedQueuePosition())
        case 2:
            // Status Bar Info Notification
            let banner = StatusBarNotificationBanner(title: "Info Status Bar Notification", style: .info)
            banner.show(queuePosition: selectedQueuePosition())
        case 3:
            // Status Bar Warning Notification
            let banner = StatusBarNotificationBanner(title: "Warning Status Bar Notification", style: .warning)
            banner.show(queuePosition: selectedQueuePosition())
        case 4:
            // Status Bar Attributed Title Notification
            let title = "Custom Status Bar Notification"
            let attributedTitle = NSMutableAttributedString(string: title)
            attributedTitle.addAttribute(NSForegroundColorAttributeName,
                                         value: UIColor.red,
                                         range: (title as NSString).range(of: "Custom"))
            attributedTitle.addAttribute(NSForegroundColorAttributeName,
                                         value: UIColor.cyan,
                                         range: (title as NSString).range(of: "Status"))
            attributedTitle.addAttribute(NSForegroundColorAttributeName,
                                         value: UIColor.green,
                                         range: (title as NSString).range(of: "Bar"))
            attributedTitle.addAttribute(NSForegroundColorAttributeName,
                                         value: UIColor.orange,
                                         range: (title as NSString).range(of: "Notification"))
            let banner = StatusBarNotificationBanner(attributedTitle: attributedTitle)
            banner.backgroundColor = UIColor(red:0.54, green:0.40, blue:0.54, alpha:1.00)
            banner.show(queuePosition: selectedQueuePosition())
        default:
            return
        }
    }
    
    func numberOfCells(for section: Int) -> Int {
        switch section {
        case 0:
            return 5
        case 1:
            return 3
        case 2:
            return 1
        case 3:
            return 5
        default:
            return 0
        }
    }
    
    func notificationBannerTitle(for section: Int) -> String {
        switch section {
        case 0:
            return "Basic Notification Banners"
        case 1:
            return "Notification Banners with Side Views"
        case 2:
            return "Notification Banner with Custom View"
        case 3:
            return "Status Bar Notifications"
        default:
            return ""
        }
    }
    
    func blockColor(at indexPath: IndexPath) -> UIColor {
        
        if indexPath == IndexPath(row: numberOfCells(for: indexPath.section) - 1, section: 0) {
            return CustomBannerColors().color(for: .warning)
        }
        
        switch indexPath.row {
        case 0:
            return UIColor(red:0.22, green:0.80, blue:0.46, alpha:1.00)
        case 1:
            return UIColor(red:0.90, green:0.31, blue:0.26, alpha:1.00)
        case 2:
            return UIColor(red:0.23, green:0.60, blue:0.85, alpha:1.00)
        case 3:
            return UIColor(red:1.00, green:0.66, blue:0.16, alpha:1.00)
        default:
            return UIColor(red:0.54, green:0.40, blue:0.54, alpha:1.00)
        }
    }
    
    func notificationTitles(at indexPath: IndexPath) -> (String, String?) {
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
                    return ("Basic Warning Notification", "Custom Warning Color")
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
                return ("Success Notification", nil)
            case 1:
                return ("Danger Notification", nil)
            case 2:
                return ("Info Notification", nil)
            case 3:
                return ("Warning Notification", nil)
            case 4:
                return ("Custom Notification", nil)
            default:
                return ("", nil)
            }
        }
        
        return ("", nil)
    }
    
    func notificationImage(at indexPath: IndexPath) -> UIImage? {
        if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                return #imageLiteral(resourceName: "unc_logo")
            default:
                return nil
            }
        }
        
        return nil
    }
    
    func showAlert(title: String) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
}

