import XCTest
import Foundation
@testable import json_dsl

class ParserTests: XCTestCase {
    func testParseOneType() throws {
        let ast = try parse("type A { prop1: int, prop2: string }")
        XCTAssertEqual(1, ast.decls.count)
        XCTAssertEqual("A", ast.decls.first?.id.name)
        XCTAssertEqual(2, ast.decls.first?.props.count)
        XCTAssertEqual("prop1", ast.decls.first?.props.first?.id.name)
        XCTAssertEqual(PropTypeEnum.Int, ast.decls.first?.props.first?.propType.type)
    }

    func testParse2Types()  throws {
        let ast = try parse("type Machine { is_active: bool, price: double } type Com { num_cat1: float, m: Machine } ")
        XCTAssertEqual(2, ast.decls.count)
        XCTAssertEqual("Machine", ast.decls.first?.id.name)
        XCTAssertEqual("Com", ast.decls[1].id.name)
    }

    func testParseLocation()  throws {
        let ast = try parse("type Machine { is_active: bool, price: double \n}\ntype Com { num_cat1: float, m: Machine } ")
        XCTAssertEqual(2, ast.decls.count)
        XCTAssertEqual(Location(line: 1, col: 1), ast.decls.first?.loc)
        XCTAssertEqual(Location(line: 3, col: 1), ast.decls[1].loc)

        // last prop
        XCTAssertEqual("m", ast.decls[1].props.last?.id.name)
        XCTAssertEqual(PropTypeEnum.RefDecl("Machine"), ast.decls[1].props.last?.propType.type)
        XCTAssertEqual(Location(line: 3, col: 29), ast.decls[1].props.last?.loc)
    }

    private func parse(_ src: String) throws -> Ast {
        let lexer = Lexer(src)
        let tokens = try lexer.scanToEnd()
        let parser = Parser(tokens)
        return try parser.parse()
    }
}