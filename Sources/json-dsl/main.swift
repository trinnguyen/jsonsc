import ArgumentParser
import Foundation

struct Driver: ParsableCommand {
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
        let str = try String(contentsOfFile: path)

        // part 1: run lexer
        print("Start lexer")
        let lexer = Lexer(src: str)
        var tok: Token
        repeat {
            tok = lexer.nextTok()

            // print tok
            print(tok)
        } while (tok.tokType != TokType.Eof)

        print("EOF")
    }
}

// entry point
Driver.main()

