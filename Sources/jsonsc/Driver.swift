import Foundation

struct Driver {

    public func run(_ path: String) throws {
        let str = try String(contentsOfFile: path)
        try runContent(str)
    }

    func runContent(_ src: String) throws {
        try runContent(src, output: CompositeOutput([ConsoleOutput(), FileOutput(".output")]))
    }

    func runContent(_ src: String, output: OutputProtocol) throws {
        // Step 1: Lexer
        print("-- Step 1: Start lexer")
        let lexer = Lexer(src)
        let tokens = try lexer.scanToEnd()

        // Step 2: Parser
        print(tokens)
        print("-- Step 2: Start parser")
        let parser = Parser(tokens)
        let ast = try parser.parse()
        print(ast)

        // Step 3: Analyser
        print("-- Step 3: Analyse")
        let analyser = Analyser(ast)
        let newAst = try analyser.analyse()
        print(newAst)

        // Step 4: Transform
        print("-- Step 4: Transform to model")
        let transformer = Transformer(newAst)
        let module = try transformer.transform()
        print(module)

        // Step 5: Generate
        let generator = Generator(module, writer: output)
        generator.generate()
    }
}
