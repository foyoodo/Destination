// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Destination",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "Destination", targets: ["Destination"]),
    ],
    targets: [
        .target(name: "Destination"),
    ]
)
