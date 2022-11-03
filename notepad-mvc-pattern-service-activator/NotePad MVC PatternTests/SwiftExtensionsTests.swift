//
//  StringExtensionsTests.swift
//  NotePad MVC PatternTests
//
//  Created by inputlagged on 8/25/22.
//

@testable import NotePad_MVC_Pattern
import XCTest


class StringExtensionsTests: XCTestCase {
    
    func testGetExtension() {
        let string = "serviceActivator.java"
        XCTAssertEqual(string.getExtension(), "java")
    }
    
    func testOffset() {
        let string = "serviceActivator"
        XCTAssertEqual(string[1], "e")
    }

    func testLatinCharacterAndNumbersOnly() {
        let cyrillicString = "123сс"
        let latinString = "123ss"
        XCTAssertEqual(cyrillicString.latinCharactersAndNumbersOnly, false)
        XCTAssertEqual(latinString.latinCharactersAndNumbersOnly, true)
    }
}

