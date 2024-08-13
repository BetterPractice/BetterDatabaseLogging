// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BetterDatabaseLogging",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
        .watchOS(.v8),
        .tvOS(.v15),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "BetterDatabaseLogging",
            targets: ["BetterDatabaseLogging"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/marcoarment/Blackbird",
                .upToNextMajor(from: "0.5.0")),
        .package(
            url: "https://github.com/BetterPractice/BetterLogging",
            branch: "main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "BetterDatabaseLogging",
            dependencies: ["Blackbird", "BetterLogging"]),
        .testTarget(
            name: "BetterDatabaseLoggingTests",
            dependencies: ["BetterDatabaseLogging"]),
    ]
)
