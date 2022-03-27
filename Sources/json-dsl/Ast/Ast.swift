import Foundation

protocol AstNode {
    var loc: Location { get }
}

struct Ast: CustomStringConvertible {
    let decls: [Decl]

    var description: String {
        decls.map({"\($0)"}).joined(separator: "\n")
    }
}

struct Decl: AstNode, CustomStringConvertible {
    let loc: Location
    let id: Id
    let props: [PropDecl]

    var description: String {
        "- Decl: \(id)\n\(props.map({"\($0)"}).joined(separator: "\n"))"
    }
}

struct PropDecl: AstNode, CustomStringConvertible {
    let loc: Location
    let id: Id
    let propType: PropType

    var description: String {
        "\t- PropDecl\n\t\tid: \(id)\n\t\ttype: \(propType)"
    }
}

struct PropType: AstNode, CustomStringConvertible {
    let loc: Location
    let type: PropTypeEnum
    var description: String {
        "\(type)"
    }
}

struct Id: AstNode, CustomStringConvertible {
    let loc: Location
    let name: String

    var description: String {
        name
    }
}

enum PropTypeEnum: Equatable {
    case RefDecl(_ name: String)
    case String
    case Bool
    case Int
    case Float
    case Double
}