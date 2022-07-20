//
//  CalculateModel.swift
//  MPG
//
//  Created by Krasivo on 20.07.2022.
//

import Foundation

class CalculateModel {
    
    private let viewer: CalculateViewer
    private let resultsCalculate: ResultsCalculate
    
    init(viewer: CalculateViewer) {
        self.viewer = viewer
        resultsCalculate = ResultsCalculate()
    }
    
    public func totalResult() {
        
        let litr = Double(viewer.calculateView.litrTextField.text ?? "1") ?? 1
        
        let km = Double(viewer.calculateView.kmTextField.text ?? "1") ?? 1
        
        viewer.update(text: resultsCalculate.totalGasoline(litr: litr,
                                                           km: km))
        
    }
}
