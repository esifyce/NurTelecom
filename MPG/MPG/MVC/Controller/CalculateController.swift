//
//  CalculateController.swift
//  MPG
//
//  Created by Krasivo on 20.07.2022.
//

import Foundation

class CalculateController {
    
    let model: CalculateModel
    
    init(viewer: CalculateViewer) {
        model = CalculateModel(viewer: viewer)
    }
    
    func calcNumberController() {
        model.totalResult()
    }
}
