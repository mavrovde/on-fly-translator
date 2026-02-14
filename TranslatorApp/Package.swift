// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TranslatorApp",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "TranslatorApp", targets: ["TranslatorApp"]),
        .library(name: "TranslatorLib", type: .dynamic, targets: ["TranslatorLib"])
    ],
    targets: [
        // The main executable
        .executableTarget(
            name: "TranslatorApp",
            dependencies: ["TranslatorLib"],
            path: "Sources",
            exclude: ["GoogleGeminiService.swift", "InputMonitor.swift", "Logger.swift"], // Dummy replacement to trigger view_file.
            sources: ["main.swift", "AppDelegate.swift"] // Executable specific
        ),
        // The library containing logic (easier to test)
        .target(
            name: "TranslatorLib",
            path: "Sources",
            exclude: ["main.swift", "AppDelegate.swift"], // Library logic
            sources: ["GoogleGeminiService.swift", "InputMonitor.swift", "Logger.swift"]
        ),
        // The tests
        .testTarget(
            name: "TranslatorTests",
            dependencies: ["TranslatorLib"],
            path: "Tests",
            linkerSettings: [
                .linkedFramework("XCTest")
            ]
        )
    ]
)
