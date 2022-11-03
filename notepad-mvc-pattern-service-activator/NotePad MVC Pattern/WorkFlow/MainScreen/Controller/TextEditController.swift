//
//  TextEditController.swift
//  NotePad MVC Pattern
//
//  Created by inputlagged on 8/11/22.
//

import UIKit

final class TextEditController {
    
    // MARK: - let/var
    
    public var textEditViewer: TextEditViewer?
    
    
    // MARK: - Init
    
    init(viewer: TextEditViewer) {
        self.textEditViewer = viewer
    }
    
    // MARK: - Public funcs
    
    public func readFromFile() {
        var array = [String]()
        let fileReader = try? FileReader(url: (textEditViewer?.manager.currentDirectory!)!)
        while let line = fileReader?.readLine() {
            array.append(line + "\n")
        }
        let textFromFile = array.joined(separator: "")
        textEditViewer?.textView.text = textFromFile
    }
    
    public func performAction(command: String) {
        if command == "undo" {
            undo()
        } else if command == "redo" {
            redo()
        } else if command == "cut" {
            cut()
        } else if command == "copy" {
            copy()
        } else if command == "paste" {
            paste()
        } else if command == "saveAs" {
            saveAs()
        } else if command == "remove" {
            remove()
        } else if command == "find" {
            self.textEditViewer?.activateFind()
        } else if command == "replaceAlert" {
            self.textEditViewer?.replaceAlert()
        } else if command == "replace" {
            replace()
        } else if command == "goToAlert" {
            self.textEditViewer?.goToAlert()
        } else if command == "goTo" {
            goTo()
        } else if command == "selectAll" {
            selectAll()
        } else if command == "timeAndDate" {
            timeAndDate()
        } else if command == "printDocument" {
            printDocument()
        } else if command == "exit" {
            tapExit()
        } else if command == "hoku" {
            hoku()
        } else if command == "saveAttributes" {
            saveAttributes()
        }
    }
    
    // MARK: - Private funcs
    
    private func undo() {
        textEditViewer?.textView.undoManager?.undo()
    }
    
    private func redo() {
        textEditViewer?.textView.undoManager?.redo()
    }
    
    private func cut() {
        let textView = textEditViewer?.textView
        if let textRange = textView?.selectedTextRange {
            let selectedText = textView!.text(in: textRange)
            UIPasteboard.general.string = selectedText
            textView?.replace(textRange, withText: "")
        }
    }
    
    private func copy() {
        let textView = textEditViewer?.textView
        if let textRange = textView?.selectedTextRange {
            let selectedText = textView!.text(in: textRange)
            UIPasteboard.general.string = selectedText
        }
    }
    
    private func paste() {
        let textView = textEditViewer?.textView
        
        if let textRange = textView?.selectedTextRange {
            if let textFromPasteboard = UIPasteboard.general.string {
                textView?.replace(textRange, withText: textFromPasteboard)
            }
        }
    }
    
    private func saveAs() {
        let textView = textEditViewer?.textView.text
        let storyBoard = UIStoryboard(name: "SaveAsStoryboard", bundle: nil)

        if let navigationVC = storyBoard.instantiateViewController(withIdentifier: "saveAsNavigation") as? UINavigationController {
            let saveAsViewer = navigationVC.topViewController as! SaveAsController
            
            saveAsViewer.fileName = textEditViewer?.fileNameTextField.text
            saveAsViewer.contentOfFile = textView
            saveAsViewer.fileFont = textEditViewer?.textView.font
            saveAsViewer.fileColor = textEditViewer?.view.backgroundColor

            textEditViewer?.present(navigationVC, animated:true, completion: nil)
        }
    }

    private func remove() {
        let textView = textEditViewer?.textView
        
        if let textRange = textView?.selectedTextRange {
            textView?.replace(textRange, withText: "")
        }
    }
    
    private func replace() {
        let originalString = textEditViewer?.originalReplacingText
        let replacingString = textEditViewer?.replacingText
        if originalString != "" && replacingString != "" {
            let text = textEditViewer?.textView.text
            textEditViewer?.textView.text = text?.replacingOccurrences(of: originalString!, with: replacingString!)
        }

    }
    
    private func goTo() {
        if let textToGo = textEditViewer?.goToText, let text = textEditViewer?.textView.text {
            if let substringRange = text.range(of: textToGo) {
                let nsRange = NSRange(substringRange, in: text)
                textEditViewer?.textView.selectedRange = nsRange
            }
        }
    }
    
    private func selectAll() {
        let textView = textEditViewer?.textView
        textView?.selectAll(nil)
    }
    
    private func timeAndDate() {
        let textView = textEditViewer?.textView
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM, yyyy" // Thursday, 11 Aug, 2022
        let currentDate = Date()
        let stringDate = formatter.string(from: currentDate)
        
        if let textRange = textView?.selectedTextRange {
            textView?.replace(textRange, withText: stringDate)
        }
    }
    
    private func printDocument() {
        let content = textEditViewer?.getTextFromTextView()
        if content!.isEmpty || content == "Введите текст" {
            textEditViewer?.customAlert(title: "Ошибка", message: "Документ пуст")
        } else {
            textEditViewer?.prepareForPrint()
        }
    }
    
    private func tapExit() {
        Darwin.exit(0)
    }
    
    private func hoku() {
        let first = "Старый пруд. \n Прыгнула в воду лягушка. \n Всплеск в тишине."
        let second = "Знает лишь время, \n Сколько дорог мне пройти, \n Чтоб достичь счастья."
        let third = "По зеркальному льду, \n Обжигая о звёзды ноги, \n Ухожу в Полнолуние…"
        let fourth = "О, с какой тоской \n Птица из клетки глядит \n На полет мотылька!"
        let fifth = "Гром прогремел - \n Словно хлопнула дверью и ушла \n Любимая навеки..."
        
        let array = [first, second, third, fourth, fifth]
        
        let random = array.randomElement()
        let showHokku = random?.description
        
        textEditViewer?.hokuAlert(title: "Хокку", message: showHokku!)

}
    
    private func saveAttributes() {
        let service = UserDefaultsService.shared
        
        if let fileName = textEditViewer?.saveNameForSettings, let color = textEditViewer?.view.backgroundColor, let font = textEditViewer?.textView.font {
            service.saveTextAttributes(fileName: fileName, color: color, font: font)
        }
    }
}
