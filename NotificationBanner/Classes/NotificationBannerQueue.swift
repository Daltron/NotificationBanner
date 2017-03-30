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

public enum QueuePosition {
    case back
    case front
}

class NotificationBannerQueue: NSObject {
    
    private static var sInstance: NotificationBannerQueue?
    static var sharedInstance: NotificationBannerQueue {
        guard let sInstance = sInstance else {
            self.sInstance = NotificationBannerQueue()
            return self.sInstance!
        }
        
        return sInstance
    }

    private var banners: [BaseNotificationBanner] = []
    
    func addBanner(_ banner: BaseNotificationBanner, queuePosition: QueuePosition) {
        
        if queuePosition == .back {
            banners.append(banner)
            
            if banners.index(of: banner) == 0 {
                banner.show(placeOnQueue: false)
            }
            
        } else {
            banner.show(placeOnQueue: false)
            
            if let firstBanner = banners.first {
                firstBanner.suspend()
            }
            
            banners.insert(banner, at: 0)
        }
        
    }
    
    func showNext(onEmpty: (() -> Void)) {
    
        banners.remove(at: 0)
        guard let banner = banners.first else {
            onEmpty()
            return
        }
        
        if banner.isSuspended {
            banner.resume()
        } else {
            banner.show(placeOnQueue: false)
        }
    }
}
