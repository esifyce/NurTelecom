//
//  FileReaderTests.swift
//  NotePad MVC PatternTests
//
//  Created by inputlagged on 8/26/22.
//

@testable import NotePad_MVC_Pattern
import XCTest

class FileReaderTests: XCTestCase {
    func testFileRead() {
        let fileReader = try? FileReader(url: URLToTestFiles.testFileURL)
        
        var array: [String] = []
        
        while let line = fileReader?.readLine() {
            array.append(line + "\n")
        }
        
        let textFromFile = array.joined(separator: "")
        let expectedResult = "let string = \"Service activator\"\nlet value = \"\"\"\n\nHello\n\n\"\"\"\n"
        XCTAssertEqual(textFromFile, expectedResult)
    }
}
