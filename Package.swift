// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "Connect",
    products: [
        .library(name: "Connect", type: .dynamic, targets: ["Connect"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Connect",
            dependencies: []
        ),
        .testTarget(
            name: "ConnectTests",
            dependencies: ["Connect"]
        ),
    ]
)
