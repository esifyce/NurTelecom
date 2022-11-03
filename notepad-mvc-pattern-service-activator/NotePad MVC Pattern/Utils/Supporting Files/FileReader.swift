//
//  FileReader.swift
//  NotePad MVC Pattern
//
//  Created by Pavel Epaneshnikov on 08.08.2022.
//

import Foundation

final class FileReader {
    
    private let fileHandle: FileHandle?
    private var buffer: Data
    private var bufferIndex: Int?
    private let chunkSize: Int
    private let delimPattern: Data
    public var encoding: String.Encoding
    private var isAtEOF: Bool = false
 
    @inlinable
        public convenience init(url: URL, delimiter: String = "\n", chunkSize: Int = 4096, encoding: String.Encoding = .utf16) throws {
            let allowExtension = ["java", "ntp", "swift", "xkt"]
            let fileHandle = try FileHandle(forReadingFrom: url)
            self.init(fileHandle: fileHandle, delimiter: delimiter, chunkSize: chunkSize, encoding: encoding)
            let fileEtension = url.lastPathComponent.getExtension()
            self.encoding = fileEtension.contains(allowExtension) ? .utf16 : .utf8
        }
    
    public init(fileHandle: FileHandle, delimiter: String = "\n", chunkSize: Int = 4096, encoding: String.Encoding = .utf8) {
        self.fileHandle = fileHandle
        self.encoding = encoding
        self.delimPattern = delimiter.data(using: self.encoding)!
        self.chunkSize = chunkSize
        self.buffer = Data(capacity: self.chunkSize)
    }
    
    public init(string: String, delimiter: String = "\n") throws {
        self.encoding = .utf8
        
        guard let stringData = string.data(using: self.encoding) else {
            throw FileReaderError.cannotCreateDataFromString
        }
        
        self.buffer = stringData
        self.bufferIndex = self.buffer.startIndex
        self.delimPattern = delimiter.data(using: self.encoding)!
        self.fileHandle = nil
        self.chunkSize = 0
    }
    
    deinit {
        fileHandle?.closeFile()
    }
    
    public func readLine() -> String? {
        if isAtEOF { return nil }
        
            if let fileHandle = self.fileHandle { // FileReader created from FileHandle
                while true {
                    if let range = buffer.range(of: self.delimPattern, options: [], in: buffer.startIndex..<buffer.endIndex) {
                        let subData = buffer.subdata(in: buffer.startIndex..<range.lowerBound)
                        let line = String(data: subData, encoding: self.encoding)
                        buffer.replaceSubrange(buffer.startIndex..<range.upperBound, with: [])
                        return line
                    }
                    else {
                        let temporaryData = fileHandle.readData(ofLength: self.chunkSize)
                        if temporaryData.count == 0 {
                            self.isAtEOF = true
                            return (self.buffer.count > 0) ? String(data: self.buffer, encoding: self.encoding) : nil
                        }
                        buffer.append(temporaryData)
                    }
                }
            }
            else if let bufferIndex = bufferIndex {
                if let range = buffer.range(of: self.delimPattern, options: [], in: bufferIndex..<buffer.endIndex) {
                    let subData = buffer.subdata(in: bufferIndex..<range.lowerBound)
                    let line = String(data: subData, encoding: self.encoding)
                    self.bufferIndex = range.upperBound
                    
                    return line
                }
            else {
                self.isAtEOF = true
                let subData = buffer.subdata(in: bufferIndex..<buffer.endIndex)
                return (subData.count > 0) ? String(data: subData, encoding: self.encoding) : nil
            }
        }
        else {
            fatalError("Ни дескриптор файла, ни индекс буфера не найдены, но то или иное должно быть создано при работе с файлом или прямой строкой. (Переведено: Google Translator")
        }
    }
}

enum FileReaderError: Error {
    case cannotCreateDataFromString
    case noFileHandleOrBufferIndexFound // needs better error handling
}
