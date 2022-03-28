
import Foundation

/**
 Generate output from ast
 */
class Generator {

    enum OutputType {
        case CSharp
        case Swift
    }

    private let module: GenModule
    private let writer: OutputProtocol

    init(_ module: GenModule, writer: OutputProtocol) {
        self.module = module
        self.writer = writer
    }

    func generate() {
        let Adapters = findAdapter(OutputType.Swift, OutputType.CSharp)
        Adapters.forEach({ $0.gen(module, writer) })
    }

    private func findAdapter(_ outputTypes: OutputType...) -> [GenAdapter] {
        outputTypes.map({ createAdapter($0) })
    }

    private func createAdapter(_ outputType: Generator.OutputType) -> GenAdapter {
        switch outputType {
        case .CSharp:
            return CSharpGenAdapter()
        case .Swift:
            return SwiftGenAdapter()
        }
    }
}