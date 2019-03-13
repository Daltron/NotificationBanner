//
//  UIWindow+Extension.swift
//  NotificationBanner
//
//  Created on 3/13/19.
//  Copyright © 2019 Dalton Hinterscher. All rights reserved.
//

import UIKit

extension UIWindow {
  
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
