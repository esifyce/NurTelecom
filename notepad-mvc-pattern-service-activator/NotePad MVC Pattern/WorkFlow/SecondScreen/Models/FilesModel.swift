//
//  FileModel.swift
//  NotePad MVC Pattern
//
//  Created by Sabir Myrzaev on 23.08.2022.
//

import Foundation

enum Mode {
    case view
    case edit
}

struct Element: Equatable {
    let name: String
    let path: URL
    let type: ElementType
}

enum ElementType: String, CaseIterable{
    case folder
    case ntp = ".ntp"
    case swift = ".swift"
    case kt = ".kt"
    case java = ".java"
    case unknown
    
    var sortPriority: Int {
     switch self {
        case .folder:
            return 0
        default:
            return 1
        }
    }
}
