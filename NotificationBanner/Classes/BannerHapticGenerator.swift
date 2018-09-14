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

public enum BannerHaptic {
    case light
    case medium
    case heavy
    case none

    @available(iOS 10.0, *)
    var impactStyle: UIImpactFeedbackGenerator.FeedbackStyle? {
        switch self {
        case .light: return .light
        case .medium: return .medium
        case .heavy: return .heavy
        case .none: return nil
        }
    }
}

open class BannerHapticGenerator: NSObject {

    /**
        Generates a haptic based on the given haptic
        -parameter haptic: The haptic strength to generate when a banner is shown
     */
    open class func generate(_ haptic: BannerHaptic) {
        if #available(iOS 10.0, *) {
            if let style = haptic.impactStyle {
                let feedbackGenerator = UIImpactFeedbackGenerator(style: style)
                feedbackGenerator.prepare()
                feedbackGenerator.impactOccurred()
            }
        }
    }
}
