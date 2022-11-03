//
//  PrintDocument.swift
//  NotePad MVC Pattern
//
//  Created by inputlagged on 8/22/22.
//

import Foundation
import UIKit

final class PrintDocument {

    // MARK: - let/var

    /*
     A4 page size
     */

    private lazy var pageWidth : CGFloat  = {
        return 8.27 * 72.0
    }()

    private lazy var pageHeight : CGFloat = {
        return 11.69 * 72.0
    }()

    private lazy var pageRect : CGRect = {
        CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
    }()

    /*
     Отступы
     */

    private lazy var marginPoint : CGPoint = {
        return CGPoint(x: 50, y: 50)
    }()

    private lazy var marginSize : CGSize = {
        return CGSize(width: self.marginPoint.x * 2 , height: self.marginPoint.y * 2)
    }()

    private let content: String
    private let font: UIFont

    // MARK: Init

    init(content: String, font: UIFont) {
        self.content = content
        self.font = font
    }

    // MARK: - Public funcs

    public func prepareData() -> Data {
        let format = UIGraphicsPDFRendererFormat()
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        let data = renderer.pdfData { (context) in
            self.addText(content, context: context)
        }

        return data
    }

    // MARK: - Private methods

    private func addText(_ text : String, context : UIGraphicsPDFRendererContext) -> CGFloat {
        let textFont = font
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
        paragraphStyle.lineBreakMode = .byWordWrapping

        let textAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: textFont
        ]

        let currentText = CFAttributedStringCreate(nil,
                                                   text as CFString,
                                                   textAttributes as CFDictionary)

        let framesetter = CTFramesetterCreateWithAttributedString(currentText!)

        var currentRange = CFRangeMake(0, 0)
        var currentPage = 0
        var done = false
        repeat {
            // Начало новой страницы
            context.beginPage()
            // Рисует номер внизу страницы
            currentPage += 1
            drawPageNumber(currentPage)
            // Отобразить текущую страницу и обновить текущий диапазон, чтобы он указывал на начало следующей.
            currentRange = renderPage(currentPage,
                                      withTextRange: currentRange,
                                      andFramesetter: framesetter)

           // Если контент закончился, выйти из цикла
            if currentRange.location == CFAttributedStringGetLength(currentText) {
                done = true
            }

        } while !done

        return CGFloat(currentRange.location + currentRange.length)
    }

    private func renderPage(_ pageNum: Int, withTextRange currentRange: CFRange, andFramesetter framesetter: CTFramesetter?) -> CFRange {
        var currentRange = currentRange
        let currentContext = UIGraphicsGetCurrentContext()

        currentContext?.textMatrix = .identity

        let frameRect = CGRect(x: self.marginPoint.x, y: self.marginPoint.y, width: self.pageWidth - self.marginSize.width, height: self.pageHeight - self.marginSize.height)
        let framePath = CGMutablePath()
        framePath.addRect(frameRect, transform: .identity)

        let frameRef = CTFramesetterCreateFrame(framesetter!, currentRange, framePath, nil)

        currentContext?.translateBy(x: 0, y: self.pageHeight)
        currentContext?.scaleBy(x: 1.0, y: -1.0)

        CTFrameDraw(frameRef, currentContext!)

        currentRange = CTFrameGetVisibleStringRange(frameRef)
        currentRange.location += currentRange.length
        currentRange.length = CFIndex(0)

        return currentRange
    }

    private func drawPageNumber(_ pageNum: Int) {
        let theFont = UIFont.systemFont(ofSize: 20)
        let pageString = NSMutableAttributedString(string: "\(pageNum)")

        pageString.addAttribute(NSAttributedString.Key.font, value: theFont, range: NSRange(location: 0, length: pageString.length))

        let pageStringSize =  pageString.size()

        let stringRect = CGRect(x: (pageRect.width - pageStringSize.width) / 2.0,
                                y: pageRect.height - (pageStringSize.height) / 2.0 - 25,
                                width: pageStringSize.width,
                                height: pageStringSize.height)

        pageString.draw(in: stringRect)
    }
}
