//
//  NotificationBannerUtilities.swift
//  NotificationBanner_Example
//
//  Created by Dalton Hinterscher on 9/19/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class NotificationBannerUtilities: NSObject {

    class func isiPhoneX() -> Bool {
        if UIDevice.current.userInterfaceIdiom != .phone {
            return false
        }
        return UIScreen.main.nativeBounds.height == 2436
    }
}
