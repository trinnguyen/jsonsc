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

struct Decl: AstNode, CustomStringConvertible, Equatable {
    let loc: Location
    let id: Id
    let props: [PropDecl]

    var description: String {
        "- Decl: \(id)\n\(props.map({"\($0)"}).joined(separator: "\n"))"
    }
}

struct PropDecl: AstNode, CustomStringConvertible, Equatable {
    let loc: Location
    let id: Id
    let propType: PropType

    var description: String {
        "\t- PropDecl\n\t\tid: \(id)\n\t\ttype: \(propType)"
    }
}

struct PropType: AstNode, CustomStringConvertible, Equatable {
    let loc: Location
    let type: PropTypeEnum
    var description: String {
        "\(type)"
    }
}

struct Id: AstNode, CustomStringConvertible, Equatable {
    let loc: Location
    let name: String

    var description: String {
        name
    }
}

enum PropTypeEnum: Equatable, CustomStringConvertible {
    case RefDecl(_ name: String)
    case AnnotatedRefDecl(_ decl: Decl)
    case String
    case Bool
    case Int
    case Float
    case Double

    var description: String {
        switch self {

        case .RefDecl(let n):
            return "RefDecl(\(n))"
        case .AnnotatedRefDecl(let d):
            return "AnnotatedRefDecl(\(d.id) - \(d.loc))"
        case .String:
            return "string"
        case .Bool:
            return "bool"
        case .Int:
            return "int"
        case .Float:
            return "float"
        case .Double:
            return "double"
        }
    }
}