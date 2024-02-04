// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "PlexKit",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v12),
        .watchOS(.v5),
        .tvOS(.v12),
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
