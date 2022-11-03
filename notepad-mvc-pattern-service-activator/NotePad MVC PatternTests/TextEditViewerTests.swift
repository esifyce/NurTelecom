//
//  TextEditViewerTests.swift
//  NotePad MVC PatternTests
//
//  Created by inputlagged on 8/26/22.
//

@testable import NotePad_MVC_Pattern
import XCTest

class TextEditViewerTests: XCTestCase {
    var sut: TextEditViewer!
    var sutController: TextEditController!
    var testText: String!

    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        sut = storyboard.instantiateViewController(withIdentifier: "TextEditViewer") as? TextEditViewer
        sutController = TextEditController(viewer: sut)
       
        sut?.loadViewIfNeeded()
        
        testText = "someText"
    }
    
    override func tearDownWithError() throws {
        sut = nil
        sutController = nil
    }

    func testStartText() {
        let startText = "Введите текст"
        XCTAssertEqual(sut.textView.text, startText)
    }
    
    func testRemoveAllText() {
        sut.textView.text = testText
        sutController.performAction(command: "selectAll")
        sutController.performAction(command: "remove")
        print(sut.textView.text)
        XCTAssertEqual(sut.textView.text, Optional(""))
    }
    
}
