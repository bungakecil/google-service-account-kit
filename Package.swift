// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "google-service-account-kit",
    platforms: [
       .macOS(.v13)
    ],
    products: [
        .library(name: "GoogleServiceAccountKit", targets: [
            "ServiceAccount"
        ]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.23.0"),
        .package(url: "https://github.com/vapor/jwt-kit.git", from: "4.13.0"),
    ],
    targets: [
        .target(name: "ServiceAccount", dependencies: [
            .product(name: "JWTKit", package: "jwt-kit"),
            .product(name: "AsyncHTTPClient", package: "async-http-client"),
        ]),
        .testTarget(name: "ServiceAccountTest", dependencies: [
            .target(name: "ServiceAccount")
        ])
    ]
)
