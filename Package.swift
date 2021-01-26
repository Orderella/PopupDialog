// swift-tools-version 5.3
import PackageDescription

let package = Package(
    name: "PopupDialog",
    platforms: [
        .iOS(.v10),
    ],
    products: [
        .library(
            name: "PopupDialog",
            targets: ["PopupDialog"]),
    ],
    dependencies: [
        // no dependencies
    ],
    targets: [
        .target(
            name: "PopupDialog",
            dependencies: []),
        .testTarget(
            name: "PopupDialogTests",
            dependencies: ["PopupDialog"]),
    ]
)
