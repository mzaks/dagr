// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Dagr",
    products: [
        .library(name: "Dagr", targets: ["Dagr"]),
        .library(name: "DagrCodeGen", targets: ["DagrCodeGen"]),
    ],
    targets: [
        .target(name: "Dagr"),
        .target(name: "DagrCodeGen"),
        .testTarget(name: "DagrTests",dependencies: ["Dagr"]),
        .testTarget(name: "DagrCodeGenTests",dependencies: ["DagrCodeGen"]),
        .executableTarget(name: "DagrCodeGenExample", dependencies: ["DagrCodeGen"]),
        .plugin(
            name: "DagrCodeGenPlugin",
            capability: .command(
                intent: .custom(verb: "dagr-code-gen", description: "Generates Dagr examples"),
                permissions: [.writeToPackageDirectory(reason: "Generate source files")]
            ),
            dependencies: ["DagrCodeGenExample"]
        ),
    ]
)
