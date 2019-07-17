//
//  CustomBannerColors.swift
//  NotificationBanner
//
//  Created by Dalton Hinterscher on 4/29/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class CustomBannerColors: BannerColors {

    /*  In this example, I only want to override the warning style. If it is not the warning style, then 
        I simply call super and return the default value.
    */
    internal override func color(for style: BannerStyle) -> UIColor {
        switch style {
            case .danger:   return super.color(for: style)
            case .info:     return super.color(for: style)
            case .customView:     return super.color(for: style)
            case .success:  return super.color(for: style)
            case .warning:  return UIColor(red:0.99, green:0.40, blue:0.13, alpha:1.00)
        }
    }
}
