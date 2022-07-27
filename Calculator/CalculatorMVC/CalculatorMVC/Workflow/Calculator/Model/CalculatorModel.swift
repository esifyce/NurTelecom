//
//  CalculatorModel.swift
//  CalculatorMVC
//
//  Created by Krasivo on 11.07.2022.
//

import UIKit

class CalculatorModel {
    
    private let viewer: CalculatorViewer
    private let reversePolishNotation: ReversePolishNotation
    private let mpgConverter: MPGConverter
    
    init(viewer: CalculatorViewer) {
        self.viewer = viewer
        reversePolishNotation = ReversePolishNotation()
        mpgConverter = MPGConverter()
    }
    
    func calculateResult() {
        sendToViewer(reversePolishNotation.calculate(viewer.calculateView.checkLabel.text?.split(separator: " ") ?? ["0.0"]))
    }
 
    private func sendToViewer(_ result: Double) {
        viewer.updateLabel(text: mpgConverter.splitNumber(result))
    }
}
