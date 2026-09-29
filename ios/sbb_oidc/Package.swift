// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "sbb_oidc",
    platforms: [
        .iOS("17.0")
    ],
    products: [
        .library(name: "sbb-oidc", targets: ["sbb_oidc"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        // MSAL iOS: https://github.com/AzureAD/microsoft-authentication-library-for-objc
        .package(url: "https://github.com/AzureAD/microsoft-authentication-library-for-objc.git", exact: "2.15.0")
    ],
    targets: [
        .target(
            name: "sbb_oidc",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "MSAL", package: "microsoft-authentication-library-for-objc")
            ],
            resources: [
                // If your plugin requires a privacy manifest, for example if it uses any required
                // reason APIs, update the PrivacyInfo.xcprivacy file to describe your plugin's
                // privacy impact, and then uncomment these lines. For more information, see
                // https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
                // .process("PrivacyInfo.xcprivacy"),
            ]
        )
    ]
)
