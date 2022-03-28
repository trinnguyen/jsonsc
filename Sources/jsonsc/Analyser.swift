import Foundation

/**
 Analyse and annotate the AST
 - Ensure ref type is declared
 - Ensure no redefined decl
 - Ensure no redefined prop
 */
class Analyser {

    private let ast: Ast
    private var table: [String: Decl] = [:]

    init(_ ast: Ast) {
        self.ast = ast
    }

    func analyse() throws -> Ast {
        // visit ast
        if ast.decls.isEmpty {
            throw AnalyserError.noDeclFound
        }

        // 1st pass: build symbol table
        for decl in ast.decls {
            let name = decl.id.name

            // redefine error
            if let d = table[name] {
                throw AnalyserError.redefinedDecl(name: name, oldLoc: d.loc, newLoc: decl.loc)
            }

            // add to table
            table[name] = decl
        }

        // 2nd pass: validate and annotate
        return try Ast(decls: ast.decls.map({ try visitDecl($0)}))
    }

    private func visitDecl(_ decl: Decl) throws -> Decl {
        var set = Set<String>()
        return try Decl(loc: decl.loc, id: decl.id, props: decl.props.map({ try visitProp(prop: $0, set: &set) }))
    }

    private func visitProp(prop: PropDecl, set: inout Set<String>) throws -> PropDecl {
        let name = prop.id.name

        // validate
        if set.contains(name) {
            throw AnalyserError.redefinedProp(name: name, newLoc: prop.loc)
        }
        set.insert(name)

        // replace id prop
        var newType = prop.propType.type
        if case PropTypeEnum.RefDecl(let name) = prop.propType.type {
            guard let d = table[name] else {
                throw AnalyserError.referencedDeclNotFound(prop)
            }

            // replace
            newType = PropTypeEnum.AnnotatedRefDecl(d)
        }

        return PropDecl(loc: prop.loc, id: prop.id, propType: PropType(loc: prop.propType.loc, type: newType))
    }
}