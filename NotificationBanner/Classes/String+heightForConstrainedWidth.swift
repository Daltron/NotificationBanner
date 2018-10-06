//
//  String+heightForConstrainedWidth.swift
//  NotificationBanner
//
//  Created by Sascha Gordner on 03.10.18.
//  Copyright © 2018 Dalton Hinterscher. All rights reserved.
//
// https://stackoverflow.com/questions/30450434/figure-out-size-of-uilabel-based-on-string-in-swift

import UIKit

public extension String {
    
    /// Calculates the height a label will need in order to display the String for the given width and font.
    ///
    /// - Parameters:
    ///   - width: Max width of the bounding rect
    ///   - font: Font used to render the string
    /// - Returns: Height a string will need to be completely visible
    func height(forConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: font], context: nil)
        return boundingBox.height
    }
}
