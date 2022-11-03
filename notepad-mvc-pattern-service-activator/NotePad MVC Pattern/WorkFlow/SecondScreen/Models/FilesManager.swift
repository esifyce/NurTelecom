//
//  FilesManager.swift
//  NotePad MVC Pattern
//
//  Created by Sabir Myrzaev on 23.08.2022.
//

import UIKit

class FilesManager {
    var mode: Mode = .view {
        didSet {
            delegate?.handleModeChange()
        }
    }
    
    var selectedElements = [Element]()
    var elements = [Element]()
    var type: ElementType = .folder
    var filesInSelectedFolder = [Element]()

    
    var currentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        didSet {
            reloadFolderContents()
        }
    }
    
    var delegate: ElementsManagerDelegate?
    
    init() {
        reloadFolderContents()
    }
    
    func switchMode(_ mode: Mode) {
        self.mode = mode
        
        switch mode {
        case .view:
            self.selectedElements = []
        case .edit:
            break
        }
    }
    
    func createElement(type: ElementType, name: String, query: String) {
        switch type {
        case .folder:
            createFolder(name: name)
        default:
            createFile(name: name, extensions: query)
        }
        reloadFolderContents()
    }
    
    func save(text: String, name: String, fileExtension: String, path: URL) {
        do {
            try text.write(
                to: path.appendingPathComponent(name + fileExtension),
                atomically: true,
                encoding: .utf16
            )
        } catch {
            print("Ошибка при попытке сохранить файл")
        }
        
    }
    
    fileprivate func createFolder(name: String) {
        guard let currentDirectory = currentDirectory else { return }

        let newFolderPath = currentDirectory.appendingPathComponent(name)
        try? FileManager.default.createDirectory(at: newFolderPath,
                                                 withIntermediateDirectories: false,
                                                 attributes: nil)
        reloadFolderContents()
    }
    
    fileprivate func createFile(name: String, extensions: String) {
        guard let currentDirectory = currentDirectory else { return }
        
        let filePath = currentDirectory.appendingPathComponent(name + extensions)
        FileManager.default.createFile(atPath: filePath.path,
                                            contents: nil,
                                            attributes: nil)
        reloadFolderContents()
    }
    
    private func reloadFolderContents() {
        guard let currentDirectory = self.currentDirectory,
              let filesUrls = try? FileManager.default.contentsOfDirectory(at: currentDirectory,
                                                                           includingPropertiesForKeys: nil) else {
            return
        }
        
        self.elements = filesUrls.map {
            let name = $0.lastPathComponent
            
            if name.contains(".ntp") {
                type = .ntp
            } else if name.contains(".swift") {
                type = .swift
            } else if name.contains(".kt") {
                type = .kt
            } else if name.contains(".java") {
                type = .java
            }
              else if !name.contains("."){
                type = .folder
            }
            else {
                type = .unknown
            }

            return Element(name: name,
                           path: $0,
                           type: type)
        }.sorted {
            $0.type.sortPriority < $1.type.sortPriority
        }
        
        delegate?.reloadData()
    }
    
    func selectElement(_ element: Element) {
        guard mode == .edit else { return }
        
        if let index = selectedElements.firstIndex(of: element) {
            selectedElements.remove(at: index)
        } else {
            selectedElements.append(element)
        }
        delegate?.reloadData()
    }
    
    func deleteSelectedElements() {
        guard mode == .edit else { return }
        
        for element in selectedElements {
            try? FileManager.default.removeItem(at: element.path)
        }
        switchMode(.view)
        reloadFolderContents()
    }
}

