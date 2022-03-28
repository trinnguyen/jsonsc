import Foundation

protocol OutputProtocol {
    func writeToFile(filename: String, content: String)
}

class CompositeOutput: OutputProtocol {

    private let writers: [OutputProtocol]

    init(_ writers: [OutputProtocol]) {
        self.writers = writers
    }

    func writeToFile(filename: String, content: String) {
        writers.forEach({$0.writeToFile(filename: filename, content: content)})
    }
}

class ConsoleOutput: OutputProtocol {
    func writeToFile(filename: String, content: String) {
        print("-- BEGIN \(filename)")
        print(content)
        print("-- END")
    }
}

class FileOutput: OutputProtocol {
    private let baseUrl: URL

    init(_ output: String) {
        baseUrl = URL(fileURLWithPath: output)
    }

    func writeToFile(filename: String, content: String) {
        do {
            // TODO create folder if missing

            // write file
            let url = baseUrl.appendingPathComponent(filename)
            try content.write(to: url, atomically: true, encoding: .utf8)
        } catch let err {
            fatalError("Failed to write to file: \(err)")
        }
    }
}