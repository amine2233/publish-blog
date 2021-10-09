// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "blog-publish",
    products: [
        .executable(
            name: "app",
            targets: ["App"]
        ),
        .library(
            name: "BlogPublish",
            type: .dynamic,
            targets: ["BlogPublish"]
        )
    ],
    dependencies: [
        .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.8.0"),
        .package(name: "SplashPublishPlugin", url: "https://github.com/johnsundell/splashpublishplugin", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "App",
            dependencies: ["BlogPublish"]
        ),
        .target(
            name: "BlogPublish",
            dependencies: ["Publish", "SplashPublishPlugin"]
        ),
        .testTarget(name: "BlogPublishTests", dependencies: ["BlogPublish"])
    ]
)
