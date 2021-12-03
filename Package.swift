// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Spek",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "Spek",
            targets: ["Spek"]
        ),
    ],
    dependencies: [],
    targets: {
        [
            .testTarget(name: "SpekTests", dependencies: ["Spek"]),
            .target(name: "SpekHelper", dependencies: []),
            .target(name: "Spek", dependencies: ["SpekHelper"])
        ]
    }(),
    swiftLanguageVersions: [.v5]
)
