/*
 
 The MIT License (MIT)
 Copyright (c) 2017 Dalton Hinterscher
 
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

public struct BannerStyle: StyleProtocol {
    static var info: BannerStyle {
        return BannerStyle(type: .info)
    }
    static var danger: BannerStyle {
        return BannerStyle(type: .danger)
    }
    static var none: BannerStyle {
        return BannerStyle(type: .none)
    }
    static var success: BannerStyle {
        return BannerStyle(type: .success)
    }
    static var warning: BannerStyle {
        return BannerStyle(type: .warning)
    }

    public var type: BannerType

    init(type: BannerType) {
        self.type = type
    }
}

public enum BannerType {
    case danger
    case info
    case none
    case success
    case warning
}


public protocol StyleProtocol {
    var type: BannerType { get set }
    var color: UIColor { get }
    //maybe add fonts here as well?
}

extension StyleProtocol {
    public var color: UIColor {
        switch self.type {
        case .danger:   return UIColor(red:0.90, green:0.31, blue:0.26, alpha:1.00)
        case .info:     return UIColor(red:0.23, green:0.60, blue:0.85, alpha:1.00)
        case .none:     return UIColor.clear
        case .success:  return UIColor(red:0.22, green:0.80, blue:0.46, alpha:1.00)
        case .warning:  return UIColor(red:1.00, green:0.66, blue:0.16, alpha:1.00)
        }
    }
}


