//
//  Helpers.swift
//  NotePad MVC PatternTests
//
//  Created by inputlagged on 8/26/22.
//

import Foundation

private class URLHelper {
    fileprivate static func fileURL(for file: String) -> URL {
        fileDirectory().appendingPathComponent(file)
    }

    fileprivate static func fileDirectory(path: String = #file) -> URL {
        let url = URL(fileURLWithPath: path)
        let testsDir = url.deletingLastPathComponent()
        let res = testsDir.appendingPathComponent("TestFile")
        return res
    }
}

enum URLToTestFiles {
    static let testFileURL = URLHelper.fileURL(for: "testFile.swift")
}





