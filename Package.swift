// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "CombineCamera",
    platforms: [
            .macOS(.v11), .iOS(.v14)
        ],
    products: [
        .library(
            name: "CombineCamera",
            targets: ["CombineCamera"]),
    ],
    targets: [
        .target(
            name: "CombineCamera",
            dependencies: [],
            path: "Sources")
    ]
)
