// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SpellCheckKit",
    platforms: [
        .macOS(.v14),
        .iOS(.v15),
    ],
    products: [
        .library(name: "SpellCheckKit", targets: ["SpellCheckKit"]),
    ],
    targets: [
        .target(name: "SpellCheckKit"),
        .testTarget(
            name: "SpellCheckKitTests",
            dependencies: ["SpellCheckKit"]
        ),
    ]
)
