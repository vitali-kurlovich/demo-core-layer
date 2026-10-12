// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "demo-core-layer",
    products: [
        .library(
            name: "CoreLayer",
            targets: ["CoreLayer"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-async-algorithms", from: "1.0.0"),
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.1.0"),
    ],
    targets: [
        .target(
            name: "CoreLayer"

        ),
        .testTarget(
            name: "CoreLayerTests",
            dependencies: [
                "CoreLayer",
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
            ]

        ),
    ],
    swiftLanguageModes: [.v6]
)
