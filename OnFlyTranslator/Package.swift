// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "OnFlyTranslator",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "OnFlyTranslator", targets: ["OnFlyTranslator"]),
        .library(name: "OnFlyTranslatorLib", type: .dynamic, targets: ["OnFlyTranslatorLib"])
    ],
    targets: [
        // The main executable
        .executableTarget(
            name: "OnFlyTranslator",
            dependencies: ["OnFlyTranslatorLib"],
            path: "Sources",
            exclude: ["GoogleGeminiService.swift", "InputMonitor.swift", "Logger.swift"], // Dummy replacement to trigger view_file.
            sources: ["main.swift", "AppDelegate.swift"] // Executable specific
        ),
        // The library containing logic (easier to test)
        .target(
            name: "OnFlyTranslatorLib",
            path: "Sources",
            exclude: ["main.swift", "AppDelegate.swift"], // Library logic
            sources: ["GoogleGeminiService.swift", "InputMonitor.swift", "Logger.swift"]
        ),
        // The tests
        .testTarget(
            name: "OnFlyTranslatorTests",
            dependencies: ["OnFlyTranslatorLib"],
            path: "Tests",
            linkerSettings: [
                .linkedFramework("XCTest")
            ]
        )
    ]
)
