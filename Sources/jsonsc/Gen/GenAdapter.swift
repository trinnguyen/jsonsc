import Foundation


protocol GenAdapter {
    func genClass(_ clazz: GenClass) -> String
    var ext: String { get }
}

extension GenAdapter {
    func gen(_ module: GenModule, _ writer: OutputProtocol) {
        module.classes.forEach({genAndWrite($0, writer)})
    }

    func genAndWrite(_ clazz: GenClass, _ writer: OutputProtocol) {
        let str = genClass(clazz)
        let fileName = "\(clazz.name).\(ext)"
        writer.writeToFile(filename: fileName, content: str)
    }
}

class CSharpGenAdapter: GenAdapter {

    var ext: String {
        "cs"
    }

    func genClass(_ clazz: GenClass) -> String {
        """
        public class \(clazz.name) {
        \t\(clazz.props.map({genProp($0)}).joined(separator: "\n\t"))
        }
        """
    }

    private func genProp(_ prop: GenProp) -> String {
        "public \(genType(prop.type)) \(prop.name) { get; set; }"
    }

    private func genType(_ type: GenType) -> String {
        switch type {

        case .int:
            return "int"
        case .bool:
            return "bool"
        case .string:
            return "string"
        case .float:
            return "float"
        case .double:
            return "double"
        case .refClass(let clazzName):
            return clazzName
        }
    }
}

class SwiftGenAdapter: GenAdapter {

    var ext: String {
        "swift"
    }

    func genClass(_ clazz: GenClass) -> String {
        """
        struct \(clazz.name) {
        \t\(clazz.props.map({genProp($0)}).joined(separator: "\n\t"))
        }
        """
    }

    private func genProp(_ prop: GenProp) -> String {
        "let \(prop.name): \(genType(prop.type))"
    }

    private func genType(_ type: GenType) -> String {
        switch type {

        case .int:
            return "Int"
        case .bool:
            return "Bool"
        case .string:
            return "String"
        case .float:
            return "Float"
        case .double:
            return "Double"
        case .refClass(let clazzName):
            return clazzName
        }
    }
}