import Foundation

/**
 A recursive-decent parser
 */
class Parser {

    let tokens: [Token]

    var index: Int = -1

    // Improve: use iterator to lazy fetching token
    init(_ tokens: [Token]) {
        self.tokens = tokens
    }

    /**
     Parse the grammar with look ahead
     - Returns: AST
     */
    func parse() throws -> Ast {
        var decls: [Decl] = []
        while true {
            guard let peek = peekTok() else {
                break
            }

            switch peek.tokType {
            case .KwType:
                decls.append(try parseDecl())
            case .Eof:
                break
            default:
                throw ParserError.unexpectedToken(expected: ["type", "eof"], actual: peek)
            }
        }
        return Ast(decls: decls)
    }

    private func parseDecl() throws -> Decl {
        let typ = try consume(.KwType)
        let id = try parseId()
        let _ = try consume(.OpenBracket)
        var props: [PropDecl] = []

        // first item
        props.append(try parsePropDecl())

        // continue with look ahead if comma
        while let tok = peekTok(), tok.tokType == .Comma {
            let _ = try consume(.Comma)
            props.append(try parsePropDecl())
        }

        let _ = try consume(.CloseBracket)

        return Decl(loc: typ.loc, id: id, props: props)
    }

    private func parseId() throws -> Id {
        let tok = try nextTok()
        switch tok.tokType {
        case .Identifier(let s):
            return Id(loc: tok.loc, name: s)
        default:
            throw ParserError.unexpectedToken(expected: ["id"], actual: tok)
        }
    }

    private func parsePropDecl() throws -> PropDecl {
        let id = try parseId()
        let _ = try consume(.Colon)
        let typ = try parsePropType()
        return PropDecl(loc: id.loc, id: id, propType: typ)
    }

    private func parsePropType() throws -> PropType {
        let tok = try nextTok()
        let type = try parsePropTypeEnum(tok)
        return PropType(loc: tok.loc, type: type)
    }

    private func parsePropTypeEnum(_ tok: Token) throws -> PropTypeEnum {
        switch tok.tokType {
        case .KwString:
            return .String
        case .KwBool:
            return .Bool
        case .KwInt:
            return .Int
        case .KwFloat:
            return .Float
        case .KwDouble:
            return .Double
        case .Identifier(let name):
            return .RefDecl(name)
        default:
            throw ParserError.unexpectedToken(expected: ["string", "bool", "int", "float", "double"], actual: tok)
        }
    }

    private func consume(_ type: TokType) throws -> Token {
        let token = try nextTok()
        if token.tokType != type {
            throw ParserError.unexpectedToken(expected: ["\(type)"], actual: token)
        }

        return token
    }

    private func peekTok() -> Token? {
        let i = peekIndex
        return i < tokens.endIndex ? tokens[i] : nil
    }

    private func nextTok() throws -> Token {
        guard let tok = peekTok() else {
            throw ParserError.tokenNotFound
        }
        index = peekIndex
        return tok
    }

    private var peekIndex: Int {
        index >= tokens.startIndex ? tokens.index(after: index) : tokens.startIndex
    }
}