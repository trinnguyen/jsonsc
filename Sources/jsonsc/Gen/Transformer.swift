import Foundation

/**
 Transform annotated AST into GenModule
 */
class Transformer {

    private let ast: Ast

    init(_ ast: Ast) {
        self.ast = ast
    }

    func transform() throws -> GenModule {
        try GenModule(classes: ast.decls.map({try transformDecl($0)}))
    }

    private func transformDecl(_ decl: Decl) throws -> GenClass {
        try GenClass(name: decl.id.name, props: decl.props.map({ try transformProp($0)} ))
    }

    private func transformProp(_ prop: PropDecl) throws -> GenProp {
        GenProp(name: prop.id.name, type: try transformType(prop.propType))
    }

    private func transformType(_ type: PropType) throws -> GenType {
        switch type.type {
        case .RefDecl(_):
            throw GeneralError.error("unexpected unannotated decl \(type)")
        case .AnnotatedRefDecl(let d):
            return .refClass(d.id.name)
        case .String:
            return .string
        case .Bool:
            return .bool
        case .Int:
            return .int
        case .Float:
            return .float
        case .Double:
            return .double
        }
    }
}