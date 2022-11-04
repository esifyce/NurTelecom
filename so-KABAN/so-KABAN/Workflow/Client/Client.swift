//
//  Client.swift
//  so-KABAN
//
//  Created by Krasivo on 29.09.2022.
//

import UIKit

public final class Client: NSObject, StreamDelegate {
    private var inputStream: InputStream!
    private var outputStream: OutputStream!
    private var maxReadLength: Int = 512
}

// MARK: - fileprivate Client methods

fileprivate extension Client {
    func readFromServer(inputStream: InputStream ) -> String {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxReadLength)
        let numberOfBytesRead = inputStream.read(buffer, maxLength: maxReadLength)
        let decodedMessage = decodeMessage(buffer: buffer, length: numberOfBytesRead)
        if var message = decodedMessage {
            message = message.replacingOccurrences(of: "\0", with: "")
            message = message.replacingOccurrences(of: "\r", with: "")
            message = message.replacingOccurrences(of: "\n", with: "")
            message = message.replacingOccurrences(of: "\u{0C}", with: "")
            message = message.replacingOccurrences(of: "\u{0B}", with: "")
            message = message.replacingOccurrences(of: "GOT_LEVEL: ", with: "")
            message = message.replacingOccurrences(of: "END_OF_MESSAGE", with: "")
            return message
        }
        return "Error request"
    }
    
    func decodeMessage(buffer: UnsafeMutablePointer<UInt8>, length: Int) -> String? {
        guard let message = String(bytesNoCopy: buffer, length: length, encoding: .utf8, freeWhenDone: true) else { return nil }
        return message
    }
}

// MARK: - public Client methods

public extension Client {
    func getDesktopFromServer(message: String) -> String {
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        let _: Void = CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                                         "194.152.37.7" as CFString,
                                                         4445,
                                                         &readStream,
                                                         &writeStream)
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        inputStream.delegate = self
        outputStream.delegate = self
        inputStream.schedule(in: .current, forMode: .common)
        outputStream.schedule(in: .current, forMode: .common)
        inputStream.open()
        outputStream.open()
        outputStream?.write(message, maxLength: message.count)
        outputStream.write("\n", maxLength: 1)
        let answer = readFromServer(inputStream: inputStream)
        return answer
    }
    
    func disconnect() {
        inputStream.close()
        outputStream.close()
    }
}

