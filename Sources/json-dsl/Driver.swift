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
        // part 1: run lexer
        print("Start lexer")
        let lexer = Lexer(src)
        var tok: Token
        repeat {
            tok = try lexer.nextTok()

            // print tok
            print(tok)
        } while (tok.tokType != TokType.Eof)
    }
}
