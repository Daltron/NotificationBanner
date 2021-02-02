//
//  UIWindow+orientation.swift
//  NotificationBannerSwift
//
//  Created by gabmarfer on 15/10/2019.
//

import UIKit

internal extension UIWindow {

    var width: CGFloat {
        let orientation = UIDevice.current.orientation
        switch orientation {
        case .landscapeLeft, .landscapeRight:
            return max(frame.width, frame.height)
        case .portrait, .portraitUpsideDown:
            return min(frame.width, frame.height)
        default:
            return frame.width
        }
    }

    var height: CGFloat {
        let orientation = UIDevice.current.orientation
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
