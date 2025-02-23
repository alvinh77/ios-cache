// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ios-cache",
    products: [
        .library(
            name: "Cache",
            targets: ["Cache"]
        )
    ],
    targets: [
        .target(name: "Cache"),
        .testTarget(
            name: "CacheTests",
            dependencies: [
                .target(name: "Cache")
            ]
        )
    ]
)
