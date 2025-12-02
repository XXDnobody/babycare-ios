// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BabyCare",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "BabyCare",
            targets: ["BabyCare"]),
    ],
    targets: [
        .target(
            name: "BabyCare",
            path: "Sources"),
    ]
)
