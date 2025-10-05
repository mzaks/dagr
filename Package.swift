// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Dagr",
    products: [
        .library(name: "Dagr", targets: ["Dagr"]),
        .library(name: "DagrCodeGen", targets: ["DagrCodeGen"]),
        .library(name: "FoundationNodes", targets: ["FoundationNodes"]),
        .library(name: "FoundationNodesDefenition", targets: ["FoundationNodesDefenition"])
    ],
    targets: [
        .target(name: "Dagr"),
        .target(name: "DagrCodeGen"),
        .target(name: "FoundationNodes", dependencies: ["Dagr"]),
        .target(name: "FoundationNodesDefenition", dependencies: ["DagrCodeGen"]),
        .testTarget(name: "DagrTests",dependencies: ["Dagr", "FoundationNodes"]),
        .testTarget(name: "DagrCodeGenTests",dependencies: ["DagrCodeGen"]),
        .executableTarget(name: "CodeGen", dependencies: ["DagrCodeGen", "FoundationNodesDefenition"]),
        .plugin(
            name: "CodeGenPlugin",
            capability: .command(
                intent: .custom(verb: "code-gen", description: "Generates graphs"),
                permissions: [.writeToPackageDirectory(reason: "Generate source files")]
            ),
            dependencies: ["CodeGen"]
        ),
    ]
)
