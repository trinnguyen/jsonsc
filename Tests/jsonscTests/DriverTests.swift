import XCTest
import Foundation

@testable import jsonsc

class DriverTests: XCTestCase {
    func testRunSuccess() throws {
        let d = Driver()
        let output = TestOutput()
        try d.runContent("type Custom { id: string, ctx_1: int }", output: output)
        XCTAssertTrue(output.dict.keys.contains("Custom.cs"))
        XCTAssertTrue(output.dict.keys.contains("Custom.swift"))
    }

    func testRunFailed() throws {
        let d = Driver()
        let output = TestOutput()
        XCTAssertThrowsError(try d.runContent("type Custom { id: string, ctx_1: int,  }", output: output))
    }
}

class TestOutput: OutputProtocol {

    var dict: [String: String] = [:]

    func writeToFile(filename: String, content: String) {
        print("write: \(filename)")
        dict[filename] = content
    }
}
