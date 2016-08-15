import PackageDescription

let package = Package(
    name: "Chameleon",
    targets: [
        Target(
            name: "App",
            dependencies: [
                .Target(name: "Bot"),
                .Target(name: "SlackSugar")
            ]
        ),
        Target(
            name: "SlackSugar",
            dependencies: [
                .Target(name: "Bot")
            ]
        ),
        Target(
            name: "Bot",
            dependencies: [
                .Target(name: "Common"),
                .Target(name: "Config"),
                .Target(name: "Models"),
                .Target(name: "Services"),
                .Target(name: "WebAPI"),
                .Target(name: "RTMAPI"),
            ]
        ),
        Target(
            name: "Common",
            dependencies: []
        ),
        Target(
            name: "Config",
            dependencies: [
                .Target(name: "Common")
            ]
        ),
        Target(
            name: "Models",
            dependencies: [
                .Target(name: "Common")
            ]
        ),
        Target(
            name: "Services",
            dependencies: [
                .Target(name: "Common")
            ]
        ),
        Target(
            name: "WebAPI",
            dependencies: [
                .Target(name: "Common"),
                .Target(name: "Services"),
                .Target(name: "Models")
            ]
        ),
        Target(
            name: "RTMAPI",
            dependencies: [
                .Target(name: "Common"),
                .Target(name: "Services"),
                .Target(name: "Models")
            ]
        )
    ],
    dependencies: [
        .Package(url: "https://github.com/qutheory/engine.git", majorVersion: 0, minor: 4),
        .Package(url: "https://github.com/qutheory/vapor-tls", majorVersion: 0, minor: 4),
//        .Package(url: "https://github.com/czechboy0/Redbird.git", majorVersion: 0, minor: 9),
        .Package(url: "https://github.com/czechboy0/Environment.git", majorVersion: 0, minor: 5),
    ],
    exclude: [
        "XcodeProject"
    ]
)
