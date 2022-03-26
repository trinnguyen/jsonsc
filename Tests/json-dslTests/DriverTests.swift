import XCTest
import Foundation

@testable import json_dsl

class DriverTests: XCTestCase {
    func testRun() throws {
        let d = Driver()
        try d.runContent("typ {}")
    }
}
