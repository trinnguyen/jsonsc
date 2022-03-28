import Foundation

enum GeneralError: Error, Equatable {
    case lexerUnexpectedChar(ch: Character, loc: Location)
    case parserUnexpectedTok(_ tok: Token)
    case parserExpectedTok(expected: Token, actual: Token)
    case error(_ msg: String)
}

enum ParserError: Error, Equatable, CustomStringConvertible {
    case unexpectedToken(expected: [String], actual: Token)
    case tokenNotFound

    var description: String {
        switch self {
        case .unexpectedToken(expected: let expected, actual: let actual):
            let msg = expected.map({"'\($0)'"}).joined(separator: " or ")
            return "expected \(msg) but \(actual)"
        case .tokenNotFound:
            return "token not found"
        }
    }
}

enum AnalyserError: Error, Equatable {
    case noDeclFound
    case redefinedDecl(name: String, oldLoc: Location, newLoc: Location)
    case redefinedProp(name: String, newLoc: Location)
    case referencedDeclNotFound(_ prop: PropDecl)
}