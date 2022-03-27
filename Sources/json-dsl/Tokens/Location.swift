import Foundation

struct Location: Equatable, CustomStringConvertible {
    let line: Int
    let col: Int

    var description: String {
        "\(line):\(col)"
    }
}
