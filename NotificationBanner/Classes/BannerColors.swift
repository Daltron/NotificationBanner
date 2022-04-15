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
public protocol BannerColorsProtocol {
    func color(for style: BannerStyle) -> UIColor
}

public class BannerColors: BannerColorsProtocol {

    public func color(for style: BannerStyle) -> UIColor {
        switch style {
        case .danger:
        return #colorLiteral(red: 1, green: 0.9490196078, blue: 0.7843137255, alpha: 1)
        case .info:
        return #colorLiteral(red: 0.8705882353, green: 0.9254901961, blue: 0.9764705882, alpha: 1)
        case .customView:
        return #colorLiteral(red: 0.8, green: 0.9333333333, blue: 0.937254902, alpha: 1)
        case .success:
        return #colorLiteral(red: 0.8078431373, green: 0.9411764706, blue: 0.8039215686, alpha: 1)
        case .warning:
        return #colorLiteral(red: 0.9803921569, green: 0.8117647059, blue: 0.8117647059, alpha: 1)
        case .info1:
        return #colorLiteral(red: 0.8, green: 0.9333333333, blue: 0.937254902, alpha: 1)
        default:
            return #colorLiteral(red: 0.8, green: 0.9333333333, blue: 0.937254902, alpha: 1)
        }
    }
}
