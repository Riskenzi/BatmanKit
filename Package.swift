// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BatmanKit",
    platforms: [
        // Add support for all platforms starting from a specific version.
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "BatmanKit",
            targets: ["BatmanKit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/kirualex/SwiftyGif.git", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/SnapKit/SnapKit.git", .branch("develop")),
        .package(url: "https://github.com/bizz84/SwiftyStoreKit.git", .branch("master")),
        .package(url: "https://github.com/realm/realm-cocoa", .branch("master")),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.2.0")),
        //https://github.com/ReactiveX/RxSwift.git
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "BatmanKit",
            dependencies: ["SwiftyGif","SnapKit","SwiftyStoreKit",.product(name: "RealmSwift", package: "realm-cocoa"),"RxSwift",
                           .product(name: "RxCocoa", package: "RxSwift")]),
        .testTarget(
            name: "BatmanKitTests",
            dependencies: ["BatmanKit"]),
    ]
)
