
Pod::Spec.new do |s|
    s.name             = 'NotificationBannerSwift'
    s.version          = '1.8.0'
    s.summary          = 'The easiest way to display in app notification banners in iOS.'

    s.description      = <<-DESC
NotificationBanner is an extremely customizable and lightweight library that makes the task of displaying in app notification banners and drop down alerts an absolute breeze in iOS.
                       DESC

    s.homepage         = 'https://github.com/Daltron/NotificationBanner'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Daltron' => 'daltonhint4@gmail.com' }
    s.source           = { :git => 'https://github.com/Daltron/NotificationBanner.git', :tag => s.version.to_s }

    s.ios.deployment_target = '9.0'

    s.source_files = 'NotificationBanner/Classes/**/*'

    s.dependency 'SnapKit', '~> 4.0.1'
    s.dependency 'MarqueeLabel/Swift', '~> 3.2.0'

end
