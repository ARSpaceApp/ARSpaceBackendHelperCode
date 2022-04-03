// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ARSpaceBackendHelperCode",
    platforms: [.macOS(.v10_15), .iOS(.v13)],
    products: [
        .library(
            name: "ARSpaceBackendHelperCode",
            targets: ["ARSpaceBackendHelperCode"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/jwt.git", from: "4.0.0-rc.2"),
        .package(name: "AWSSDKSwift", url: "https://github.com/swift-aws/aws-sdk-swift.git", from: "4.0.0")
    ],
    targets: [
        .target(
            name: "ARSpaceBackendHelperCode",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "JWT", package: "jwt"),
                .product(name: "S3", package: "AWSSDKSwift"),
                .product(name: "SES", package: "AWSSDKSwift"),
                .product(name: "IAM", package: "AWSSDKSwift")
            ]),
        .testTarget(
            name: "ARSpaceBackendHelperCodeTests",
            dependencies: ["ARSpaceBackendHelperCode"]),
    ]
)
