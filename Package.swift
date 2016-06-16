import PackageDescription

let package = Package(
    name: "Chameleon",
    dependencies: [
        .Package(url: "https://github.com/Zewo/WebSocketClient.git", majorVersion: 0, minor: 1),
        .Package(url: "https://github.com/IanKeen/Jay.git", majorVersion: 0, minor: 0),
        .Package(url: "https://github.com/czechboy0/Redbird.git", majorVersion: 0, minor: 7),
        .Package(url: "https://github.com/ketzusaka/Strand.git", majorVersion: 1, minor: 3),
    ],
    exclude: [
        "XcodeProject"
    ],
    targets: [
        Target(
            name: "App",
            dependencies: [
                .Target(name: "Common"),
                .Target(name: "Services"),
                .Target(name: "Models"),
                .Target(name: "RTMAPI"),
                .Target(name: "WebAPI"),
                .Target(name: "Bot"),
            ]
        ),
        Target(
            name: "Services"
        ),
        Target(
            name: "Common"
        ),
        Target(
            name: "Models",
            dependencies: [
                .Target(name: "Common"),
            ]
        ),
        Target(
            name: "WebAPI",
            dependencies: [
                .Target(name: "Common"),
                .Target(name: "Models"),
                .Target(name: "Services"),
            ]
        ),
        Target(
            name: "RTMAPI",
            dependencies: [
                .Target(name: "Common"),
                .Target(name: "Models"),
                .Target(name: "Services"),
            ]
        ),
        Target(
            name: "Bot",
            dependencies: [
                .Target(name: "WebAPI"),
                .Target(name: "RTMAPI"),
            ]
        )
    ]
)

