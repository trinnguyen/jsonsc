import Foundation

enum GeneralError: Error, Equatable {
    case lexerUnexpectedChar(ch: Character, loc: Location)
}