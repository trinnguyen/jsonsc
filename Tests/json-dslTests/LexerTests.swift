
import XCTest

import Foundation
@testable import json_dsl

class LexerTests: XCTestCase {

    func testKeywords() throws {
        let lexer = Lexer("type string bool int float double")
        XCTAssertEqual(TokType.KwType, try lexer.nextTok().tokType)
        XCTAssertEqual(TokType.KwString, try lexer.nextTok().tokType)
        XCTAssertEqual(TokType.KwBool, try lexer.nextTok().tokType)
        XCTAssertEqual(TokType.KwInt, try lexer.nextTok().tokType)
        XCTAssertEqual(TokType.KwFloat, try lexer.nextTok().tokType)
        XCTAssertEqual(TokType.KwDouble, try lexer.nextTok().tokType)
        XCTAssertEqual(TokType.Eof, try lexer.nextTok().tokType)
    }

    func testSymbols() {
        let lexer = Lexer("{ } : , ,")
        XCTAssertEqual(TokType.OpenBracket, try lexer.nextTok().tokType)
        XCTAssertEqual(TokType.CloseBracket, try lexer.nextTok().tokType)
        XCTAssertEqual(TokType.Colon, try lexer.nextTok().tokType)
        XCTAssertEqual(TokType.Comma, try lexer.nextTok().tokType)
        XCTAssertEqual(TokType.Comma, try lexer.nextTok().tokType)
        XCTAssertEqual(TokType.Eof, try lexer.nextTok().tokType)
    }

    func testId() {
        let lexer = Lexer("name Name Foo foo f1 active_1")
        XCTAssertEqual(TokType.Identifier("name"), try lexer.nextTok().tokType)
        XCTAssertEqual(TokType.Identifier("Name"), try lexer.nextTok().tokType)
        XCTAssertEqual(TokType.Identifier("Foo"), try lexer.nextTok().tokType)
        XCTAssertEqual(TokType.Identifier("foo"), try lexer.nextTok().tokType)
        XCTAssertEqual(TokType.Identifier("f1"), try lexer.nextTok().tokType)
        XCTAssertEqual(TokType.Identifier("active_1"), try lexer.nextTok().tokType)
        XCTAssertEqual(TokType.Eof, try lexer.nextTok().tokType)
    }

    func testInvalidIdWithNumber() {
        let lexer = Lexer("9_id")
        XCTAssertThrowsError(try lexer.nextTok()) { error in
            XCTAssertEqual(error as? GeneralError, .lexerUnexpectedChar(ch: "9", loc: Location(line: 1, col: 1)))
        }
    }

    func testInvalidIdWithUnderscore() throws {
        let lexer = Lexer("a _id")
        let _ = try lexer.nextTok()

        XCTAssertThrowsError(try lexer.nextTok()) { error in
            XCTAssertEqual(error as? GeneralError, .lexerUnexpectedChar(ch: "_", loc: Location(line: 1, col: 3)))
        }
    }

    func testFullType() throws {
        let lexer = Lexer("type Foo_100 {\nname: string,\ncount: int\n}")
        XCTAssertEqual(Token(tokType: TokType.KwType, loc: Location(line: 1, col: 1)), try lexer.nextTok())
        XCTAssertEqual(Token(tokType: TokType.Identifier("Foo_100"), loc: Location(line: 1, col: 6)), try lexer.nextTok())
        XCTAssertEqual(Token(tokType: TokType.OpenBracket, loc: Location(line: 1, col: 14)), try lexer.nextTok())
        XCTAssertEqual(Token(tokType: TokType.Identifier("name"), loc: Location(line: 2, col: 1)), try lexer.nextTok())
        XCTAssertEqual(Token(tokType: TokType.Colon, loc: Location(line: 2, col: 5)), try lexer.nextTok())
        XCTAssertEqual(Token(tokType: TokType.KwString, loc: Location(line: 2, col: 7)), try lexer.nextTok())
        XCTAssertEqual(Token(tokType: TokType.Comma, loc: Location(line: 2, col: 13)), try lexer.nextTok())
        XCTAssertEqual(Token(tokType: TokType.Identifier("count"), loc: Location(line: 3, col: 1)), try lexer.nextTok())
        XCTAssertEqual(Token(tokType: TokType.Colon, loc: Location(line: 3, col: 6)), try lexer.nextTok())
        XCTAssertEqual(Token(tokType: TokType.KwInt, loc: Location(line: 3, col: 8)), try lexer.nextTok())
        XCTAssertEqual(Token(tokType: TokType.CloseBracket, loc: Location(line: 4, col: 1)), try lexer.nextTok())
        XCTAssertEqual(Token(tokType: TokType.Eof, loc: Location(line: 4, col: 2)), try lexer.nextTok())
    }
}
