// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private let packageName = "Colors"

private enum Targets: String, CaseIterable {
    case colors = "Colors"
}

let package = Package(
    name: packageName,
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: packageName,
            targets: Targets.allCases.map { $0.rawValue }),
    ],
    targets: [
        .target(
            name: Targets.colors.rawValue,
            dependencies: []),
    ]
)
