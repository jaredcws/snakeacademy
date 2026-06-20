// swift-tools-version: 5.9

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "SnakeAcademy",
    defaultLocalization: "en",
    platforms: [
        .iOS("17.0")
    ],
    products: [
        .iOSApplication(
            name: "SnakeAcademy",
            targets: ["AppModule"],
            bundleIdentifier: "com.jaredcws.SnakeAcademy",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .asset("AppIcon"),
            accentColor: .asset("AccentColor"),
            supportedDeviceFamilies: [
                .phone,
                .pad
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ],
            appCategory: .games
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: "AppModule",
            resources: [
                .process("Assets.xcassets"),
                .process("Resources")
            ]
        )
    ]
)
