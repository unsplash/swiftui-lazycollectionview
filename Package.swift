// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "LazyCollectionView",
    platforms: [
        .iOS(.v14),
        .macOS(.v12),
        .visionOS(.v1)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "LazyCollectionView",
            targets: ["LazyCollectionView"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "LazyCollectionView",
            dependencies: [])
    ]
)
