// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Bus",
    defaultLocalization: "ru",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Bus",
            targets: ["Bus"]),
    ],
    dependencies: [
        .package(name: "MMCoreNetwork", url: "https://github.com/MosMetro-official/MMCoreNetwork", .exactItem("0.0.3-callbacks")),
        .package(url: "https://github.com/MosMetro-official/CoreTableView", from: "0.0.6"),
        .package(url: "https://github.com/marmelroy/Localize-Swift", from: "3.2.0"),
        .package(url: "https://github.com/scenee/FloatingPanel", from: "2.0.0"),
        .package(url: "https://github.com/krisk/fuse-swift", from: "1.0.0"),
        .package(url: "https://github.com/malcommac/SwiftDate", from: "6.0.0"),
        .package(url: "https://github.com/realm/realm-swift", from: "3.19.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImage", from: "5.0.0"),
        .package(url: "https://github.com/marcosgriselli/ViewAnimator", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "Bus",
            dependencies: [
                .product(name: "Localize_Swift", package: "Localize-Swift"),
                .product(name: "FloatingPanel", package: "FloatingPanel"),
                .product(name: "Fuse", package: "fuse-swift"),
                .product(name: "SwiftDate", package: "SwiftDate"),
                .product(name: "RealmSwift", package: "realm-swift"),
                .product(name: "SDWebImage", package: "SDWebImage"),
                .product(name: "ViewAnimator", package: "ViewAnimator"),
                "MMCoreNetwork",
                "CoreTableView"
            ],
            resources: [
                .copy("Fonts/MoscowSans-Bold.otf"),
                .copy("Fonts/MoscowSans-Regular.otf"),
                .copy("Fonts/MoscowSans-Medium.otf"),
                .copy("Fonts/MoscowSans-Extrabold.otf"),
                .copy("Fonts/MoscowSans-Light.otf")
            ]
        ),
        .testTarget(
            name: "BusTests",
            dependencies: ["Bus"]
        ),
    ]
)
