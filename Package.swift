// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "on-fly-translator",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "on-fly-translator", targets: ["on-fly-translator"])
    ],
    targets: [
        .executableTarget(
            name: "on-fly-translator",
            path: "Sources"
        ),
        .testTarget(
            name: "on-fly-translator-tests",
            dependencies: ["on-fly-translator"],
            path: "Tests"
        )
    ]
)
