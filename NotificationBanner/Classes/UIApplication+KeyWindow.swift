//
//  UIApplication+KeyWindow.swift
//  CoreUtils
//
//  Created by João Moreira on 10/05/2025.
//

import UIKit

extension UIApplication {
    
    var firstKeyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .first(where: { $0 is UIWindowScene })
            .flatMap { $0 as? UIWindowScene }?.windows
            .first(where: \.isKeyWindow)
    }
    
    var orientation: UIInterfaceOrientation? {
        if #available(iOS 16, *) {
            return firstKeyWindow?.windowScene?.effectiveGeometry.interfaceOrientation
        }
        return firstKeyWindow?.windowScene?.interfaceOrientation
    }
    
}
