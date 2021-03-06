import Foundation

class Lexer {

    private let src: String

    private var line = 1

    private var col = 1

    private var index: String.Index?

    private let endIndex: String.Index

    /// Init lexer with source code
    /// - Parameter src: source content
    init(_ src: String) {
        self.src = src
        self.endIndex = self.src.endIndex
    }

    func nextTok() throws -> Token {
        let loc = getLoc()
        switch nextChar() {
        case .none:
            return Token(tokType: .Eof, loc: getLoc())
        case .some(let c):

            // advanced if whitespace (include newlines)
            if c.isWhitespace {
                return try nextTok()
            }

            // check if identifier
            if c.isLetter {
                var id = "\(c)"
                while true {
                    guard let nextC = peekChar(), nextC.isValidIdChar else {
                        break
                    }
                    id.append(nextC)

                    // advance index
                    _ = nextChar()
                }

                if let keyword = scanKeyword(id) {
                    return Token(tokType: keyword, loc: loc)
                }

                // summary id
                return Token(tokType: .Identifier(id), loc: loc)
            }

            // start parsing
            switch c {
            case "{":
                return Token(tokType: .OpenBracket, loc: loc)
            case "}":
                return Token(tokType: .CloseBracket, loc: loc)
            case ":":
                return Token(tokType: .Colon, loc: loc)
            case ",":
                return Token(tokType: .Comma, loc: loc)
            default:
                throw GeneralError.lexerUnexpectedChar(ch: c, loc: loc)
            }
        }
    }

    func scanToEnd() throws -> [Token] {
        var tokens: [Token] = []
        while true {
            let tok = try nextTok()
            if tok.tokType == TokType.Eof {
                break
            }
            tokens.append(tok)
        }

        return tokens
    }

    private func scanKeyword(_ id: String) -> TokType? {
        switch id {
        case "type":
            return TokType.KwType;
        case "int":
            return TokType.KwInt;
        case "string":
            return TokType.KwString;
        case "bool":
            return TokType.KwBool;
        case "float":
            return TokType.KwFloat;
        case "double":
            return TokType.KwDouble;
        default:
            return nil
        }
    }

    private func getLoc() -> Location {
        Location(line: line, col: col)
    }

    private func peekChar() -> Character? {
        // find next index
        let next = nextIndex()
        if next < endIndex {
            return src[next]
        }

        return nil
    }

    private func nextChar() -> Character? {
        guard let c = peekChar() else {
            return nil
        }

        // increase col and line if needed
        col = col + 1
        if c.isNewline {
            line = line + 1
            col = 1
        }

        // advanced
        index = nextIndex()

        return c
    }

    private func nextIndex() -> String.Index {
        if let i = index {
            return src.index(after: i)
        } else {
            return src.startIndex
        }
    }
}

extension Character {
    var isValidIdChar: Bool {
        isLetter || isNumber || self == "_"
    }
}
