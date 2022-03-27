import XCTest
import Foundation

@testable import jsonsc

class DriverTests: XCTestCase {
    func testRunSuccess() throws {
        let d = Driver()
        try d.runContent("type Custom { id: string, ctx_1: int }")
    }

    func testRunFailed() throws {
        let d = Driver()
        XCTAssertThrowsError(try d.runContent("type Custom { id: string, ctx_1: int,  }"))
    }
}
