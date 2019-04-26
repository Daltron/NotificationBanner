//
//  UIWindow+Extension.swift
//  NotificationBanner
//
//  Created on 2019-04-26.
//  Copyright © 2019 Dalton Hinterscher. All rights reserved.
//

import UIKit

extension UIWindow {

    public var width: CGFloat {
        let orientation = UIApplication.shared.statusBarOrientation
        switch orientation {
        case .landscapeLeft, .landscapeRight:
            return max(frame.width, frame.height)
        case .portrait, .portraitUpsideDown:
            return min(frame.width, frame.height)
        default:
            return frame.width
        }
    }

    public var height: CGFloat {
        let orientation = UIApplication.shared.statusBarOrientation
        switch orientation {
        case .landscapeLeft, .landscapeRight:
            return min(frame.width, frame.height)
        case .portrait, .portraitUpsideDown:
            return max(frame.width, frame.height)
        default:
            return frame.height
        }
    }
}
