// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "SimpleMDM",
    products: [
        .library(name: "SimpleMDM", targets: ["SimpleMDM"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "4.0.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "4.5.0"),
    ],
    targets: [
        .target(name: "SimpleMDM", dependencies: ["Alamofire", "SwiftyJSON"], path: "Sources"),
    ]
)
