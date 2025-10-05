//
//  CodeGenPlugin.swift
//
//
//  Created by Maxim Zaks on 07.08.25.
//

import PackagePlugin
import Foundation


@main
struct DagrStoreGenPlugin: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) async throws {
        let tool = try context.tool(named: "CodeGen")
        let outputUrl = context.package.directoryURL
        let proc = Process()
        proc.executableURL = tool.url
        proc.arguments = [outputUrl.path(percentEncoded: false)] + arguments

        try proc.run()
        proc.waitUntilExit()

        if proc.terminationStatus != 0 {
            throw PluginError.cliFailed(status: proc.terminationStatus)
        }
    }
}

enum PluginError: Error {
    case cliFailed(status: Int32)
}
