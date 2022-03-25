import Foundation

enum TokType: Equatable {
    case Eof
    case KwType
    case KwString
    case KwInt
    case KwDecimal
    case KwBool
    case Comma
    case Colon
    case OpenBracket
    case CloseBracket
    case Identifier(String)
}