import ArgumentParser
import Foundation

struct DriverCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
            commandName: "jsonsc",
            abstract: "A DSL to define JSON schema",
            subcommands: []
    )

    @Argument(help: "Path to .jsons file", completion: .file())
    var path: String

    @Flag(help: "Enable verbose logging")
    var verbose = false

    func run() throws {
        try Driver().run(path)
    }
}

// entry point
DriverCommand.main()

