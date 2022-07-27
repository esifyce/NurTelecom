//
//  String + Extension.swift
//  CalculatorMVC
//
//  Created by Krasivo on 18.07.2022.
//

import UIKit

extension String {
    var textFormatting: String {
        return self.removeLastZero.replacingDotWithPoint
    }
    private var removeLastZero: String {
        let splitValue = self.split(separator: ".")
        if splitValue.count > 1 && splitValue[1] == "0" {
            return String(splitValue[0])
        } else {
            return self
        }
    }
    private var replacingDotWithPoint: String {
        return self.replacingOccurrences(of: ".", with: ",")
    }
    
    var DoubleFormatting: String {
        return self.replacingPointWithDot
    }
    private var replacingPointWithDot: String {
        return self.replacingOccurrences(of: ",", with: ".")
    }
    
    var doubleText: Double {
        return Double(self.DoubleFormatting) ?? 0
    }
    
    var isZero: Bool {
        return self == "0"
    }
    
    var isMinusZero: Bool {
        return self == "-0"
    }
}
