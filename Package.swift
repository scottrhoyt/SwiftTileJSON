// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftTileJSON",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftTileJSON",
            targets: ["SwiftTileJSON"]),
    ],
    dependencies: [
        .package(url: "https://github.com/mxcl/Version.git", from: "2.1.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftTileJSON",
            dependencies: [
                .product(name: "Version", package: "Version")
            ]
        ),
        .testTarget(
            name: "SwiftTileJSONTests",
            dependencies: ["SwiftTileJSON"],
            resources: [.copy("Resources/")]
        ),
    ]
)
