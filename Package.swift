// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreUIKit",
    platforms: [.iOS(.v15), .macOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CoreUIKit",
            targets: ["CoreUIKit"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CoreUIKit",
            resources: [
                            .process("Resources") // This assumes your XIBs are in the Resources folder
                        ]
        ),
        .testTarget(
            name: "CoreUIKitTests",
            dependencies: ["CoreUIKit"]),
    ]
)
