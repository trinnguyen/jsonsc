import Foundation

struct Token: Equatable, CustomStringConvertible {
    var description: String {
        "\(tokType) at \(loc)"
    }

    let tokType: TokType
    let loc: Location
}
