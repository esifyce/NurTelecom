//
//  FileModel.swift
//  NotePad MVC Pattern
//
//  Created by Masaie on 29/8/22.
//

import Foundation

class FileModel: Codable {
    let name: String
    let descrtiption: String
    
    init(name: String, descrtiption: String) {
        self.name = name
        self.descrtiption = descrtiption
    }
}
