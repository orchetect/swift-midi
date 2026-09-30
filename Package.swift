// swift-tools-version: 6.0

import Foundation
import PackageDescription

let package = Package(
    name: "swift-midi",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v12),
        .tvOS(.v12),
        .watchOS(.v4)
    ],
    products: [
        .library(
            name: "SwiftMIDI",
            targets: ["SwiftMIDI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/swift-midi-controlsurfaces", exact: "1.0.1"),
        .package(url: "https://github.com/orchetect/swift-midi-core", exact: "1.0.1"),
        .package(url: "https://github.com/orchetect/swift-midi-file", exact: "1.0.1"),
        .package(url: "https://github.com/orchetect/swift-midi-io", exact: "1.1.0"),
        .package(url: "https://github.com/orchetect/swift-midi-sync", exact: "1.0.1"),
        .package(url: "https://github.com/orchetect/swift-midi-ui", exact: "1.1.0")
    ],
    targets: [
        .target(
            name: "SwiftMIDI",
            dependencies: [
                .product(name: "SwiftMIDIControlSurfaces", package: "swift-midi-controlsurfaces"),
                .product(name: "SwiftMIDICore", package: "swift-midi-core"),
                .product(name: "SwiftMIDIFile", package: "swift-midi-file"),
                .product(name: "SwiftMIDIIO", package: "swift-midi-io"),
                .product(name: "SwiftMIDISync", package: "swift-midi-sync"),
                .product(name: "SwiftMIDIUI", package: "swift-midi-ui")
            ],
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        )
    ]
)

// MARK: - Utilities

func hasEnvironmentVariable(_ name: String) -> Bool {
    ProcessInfo.processInfo.environment[name] != nil
}

// MARK: - CI Pipeline

if hasEnvironmentVariable("GITHUB_ACTIONS") {
    for target in package.targets.filter(\.isTest) {
        if target.swiftSettings == nil { target.swiftSettings = [] }
        target.swiftSettings? += [.define("GITHUB_ACTIONS", .when(configuration: .debug))]
    }
}
