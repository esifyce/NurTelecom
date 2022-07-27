//
//  CalculatorController.swift
//  CalculatorMVC
//
//  Created by Krasivo on 21.07.2022.
//

import Foundation

class CalculatorController {
    
    let model: CalculatorModel
    
    init(viewer: CalculatorViewer) {
        model = CalculatorModel(viewer: viewer)
    }
    
    func finalExpression() {
        model.calculateResult()
    }
}
