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

open class NotificationBannerQueue: NSObject {
    
    /// The default instance of the NotificationBannerQueue
    public static let `default` = NotificationBannerQueue()
    
    /// The notification banners currently placed on the queue
    private(set) var banners: [BaseNotificationBanner] = []
    
    /// The current number of notification banners on the queue
    public var numberOfBanners: Int {
        return banners.count
    }
    
    /**
        Adds a banner to the queue
        -parameter banner: The notification banner to add to the queue
        -parameter queuePosition: The position to show the notification banner. If the position is .front, the
        banner will be displayed immediately
    */
    func addBanner(_ banner: BaseNotificationBanner, queuePosition: QueuePosition) {
        
        if queuePosition == .back {
            banners.append(banner)
            
            if banners.index(of: banner) == 0 {
                banner.show(placeOnQueue: false, bannerPosition: banner.bannerPosition)
            }
            
        } else {
            banner.show(placeOnQueue: false, bannerPosition: banner.bannerPosition)
            
            if let firstBanner = banners.first {
                firstBanner.suspend()
            }
            
            banners.insert(banner, at: 0)
        }
        
    }
    
    /**
        Shows the next notificaiton banner on the queue if one exists
        -parameter callback: The closure to execute after a banner is shown or when the queue is empty
    */
    func showNext(callback: ((_ isEmpty: Bool) -> Void)) {

        if !banners.isEmpty {
          banners.removeFirst()
        }
        guard let banner = banners.first else {
            callback(true)
            return
        }
        
        if banner.isSuspended {
            banner.resume()
        } else {
            banner.show(placeOnQueue: false)
        }
        
        callback(false)
    }
    
    /**
        Removes all notification banners from the queue
    */
    public func removeAll() {
        banners.removeAll()
    }
}
