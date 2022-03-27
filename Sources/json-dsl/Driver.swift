//
// Created by Tri Nguyen on 26/03/2022.
//

import Foundation

struct Driver {

    public func run(_ path: String) throws {
        let str = try String(contentsOfFile: path)
        try runContent(str)
    }

    func runContent(_ src: String) throws {
        // Step 1: Lexer
        print("Step 1: Start lexer")
        let lexer = Lexer(src)
        let tokens = try lexer.scanToEnd()

        // Step 2: Parser
        print(tokens)
        print("Step 2: Start parser")
        let parser = Parser(tokens)
        let ast = try parser.parse()
        print(ast)
    }
}
