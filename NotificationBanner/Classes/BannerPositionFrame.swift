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

@objc
public enum BannerPosition: Int {
    case bottom
    case top
}

class BannerPositionFrame {
    
    private(set) var startFrame: CGRect!
    private(set) var endFrame: CGRect!

    init(
        bannerPosition: BannerPosition,
        bannerWidth: CGFloat,
        bannerHeight: CGFloat,
        maxY: CGFloat,
        finishYOffset: CGFloat = 0,
        edgeInsets: UIEdgeInsets?
    ) {

        self.startFrame = startFrame(
            for: bannerPosition,
            bannerWidth: bannerWidth,
            bannerHeight: bannerHeight,
            maxY: maxY,
            edgeInsets: edgeInsets
        )
        
        self.endFrame = endFrame(
            for: bannerPosition,
            bannerWidth: bannerWidth,
            bannerHeight: bannerHeight,
            maxY: maxY,
            finishYOffset: finishYOffset,
            edgeInsets: edgeInsets
        )
    }
    
    /**
        Returns the start frame for the notification banner based on the given banner position
        - parameter bannerPosition: The position the notification banners should slide in from
        - parameter bannerWidth: The width of the notification banner
        - parameter bannerHeight: The height of the notification banner
        - parameter maxY: The maximum `y` position the banner can slide in from. This value is only used 
        if the bannerPosition is .bottom
        - parameter edgeInsets: The sides edges insets from superview
     */
    private func startFrame(
        for bannerPosition: BannerPosition,
        bannerWidth: CGFloat,
        bannerHeight: CGFloat,
        maxY: CGFloat,
        edgeInsets: UIEdgeInsets?
    ) -> CGRect {
        
        let edgeInsets = edgeInsets ?? .zero
        
        switch bannerPosition {
        case .bottom:
            return CGRect(
                x: edgeInsets.left,
                y: maxY,
                width: bannerWidth - edgeInsets.left - edgeInsets.right,
                height: bannerHeight
            )
        case .top:
            return CGRect(
                x: edgeInsets.left,
                y: -bannerHeight,
                width: bannerWidth - edgeInsets.left - edgeInsets.right,
                height: bannerHeight
            )

        }
    }
    
    /**
     Returns the end frame for the notification banner based on the given banner position
     - parameter bannerPosition: The position the notification banners should slide in from
     - parameter bannerWidth: The width of the notification banner
     - parameter bannerHeight: The height of the notification banner
     - parameter maxY: The maximum `y` position the banner can slide in from. This value is only used if the bannerPosition is .bottom
     - parameter finishYOffset: The `y` position offset the banner can slide in. Used for displaying several banenrs simaltaneously
     - parameter edgeInsets: The sides edges insets from superview
     */
    private func endFrame(
        for bannerPosition: BannerPosition,
        bannerWidth: CGFloat,
        bannerHeight: CGFloat,
        maxY: CGFloat,
        finishYOffset: CGFloat = 0,
        edgeInsets: UIEdgeInsets?
    ) -> CGRect {
        
        let edgeInsets = edgeInsets ?? .zero

        switch bannerPosition {
        case .bottom:
            return CGRect(
                x: edgeInsets.left,
                y: maxY - bannerHeight - edgeInsets.bottom - finishYOffset,
                width: startFrame.width,
                height: startFrame.height)
        case .top:
            return CGRect(
                x: edgeInsets.left,
                y: edgeInsets.top + finishYOffset,
                width: startFrame.width,
                height: startFrame.height
            )
        }
    }

}
