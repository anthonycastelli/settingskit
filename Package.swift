// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SettingsKit",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(name: "SettingsKit", targets: ["SettingsKit"]),
    ],
    dependencies: [
        
    ],
    targets: [
        .target(name: "SettingsKit", dependencies: []),
        .testTarget(name: "SettingsKitTests", dependencies: ["SettingsKit"]),
    ]
)
