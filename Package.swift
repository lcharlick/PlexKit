// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PlexKit",
    platforms: [
        // Add support for all platforms starting from a specific version.
        .macOS(.v10_12),
        .iOS(.v10),
        .watchOS(.v5),
        .tvOS(.v10),
    ],
    products: [
        .library(
            name: "PlexKit",
            targets: ["PlexKit"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "PlexKit",
            dependencies: []
        ),
        .testTarget(
            name: "PlexKitTests",
            dependencies: ["PlexKit"],
            resources: [.process("Resources")]
        ),
    ]
)
