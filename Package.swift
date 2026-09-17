// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "NotificationBannerSwift",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "NotificationBannerSwift", targets: ["NotificationBannerSwift"])
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit", from: "6.0.0"),
        .package(url: "https://github.com/cbpowell/MarqueeLabel", from: "4.5.3")
    ],
    targets: [
        .target(
            name: "NotificationBannerSwift",
            dependencies: [.byName(name: "MarqueeLabel"), .byName(name: "SnapKit")],
            path: "NotificationBanner/Classes"
        )
    ],
    swiftLanguageVersions: [.v5]
)
