// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "Connect",
    products: [
        .library(name: "Connect", type: .dynamic, targets: ["Connect"]),
    ],
    dependencies: [
      .package(url: "https://github.com/vapor/jwt.git", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "Connect",
            dependencies: ["JWT"]
        ),
        .testTarget(
            name: "ConnectTests",
            dependencies: ["Connect"]
        ),
    ]
)
