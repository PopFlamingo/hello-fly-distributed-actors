// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "hello-fly-distributed-actors",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/PopFlamingo/swift-distributed-actors.git", branch: "fix-log-level-settings"),
        .package(url: "https://github.com/PopFlamingo/swift-fly-app-discovery.git", branch: "use-loglevel-fix")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "HelloFlyDistributedActors",
            dependencies: [
                .product(name: "DistributedActors", package: "swift-distributed-actors"),
                .product(name: "FlyAppDiscovery", package: "swift-fly-app-discovery")
            ]
        ),
        .testTarget(
            name: "HelloFlyDistributedActorsTests",
            dependencies: ["HelloFlyDistributedActors"]),
    ]
)
