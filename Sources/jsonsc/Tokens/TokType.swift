import Foundation

enum TokType: Equatable {
    case Eof
    case KwType
    case KwInt
    case KwString
    case KwBool
    case KwFloat
    case KwDouble
    case Comma
    case Colon
    case OpenBracket
    case CloseBracket
    case Identifier(String)
}