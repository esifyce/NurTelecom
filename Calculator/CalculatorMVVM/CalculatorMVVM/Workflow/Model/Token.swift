//
//  Token.swift
//  CalculatorMVVM
//
//  Created by Krasivo on 28.07.2022.
//

import Foundation

enum TokenType {
    case Number
    case Operator
}

class Token {
    var value: String
    var type: TokenType = TokenType.Number
    var priority: Int = 0

    init(_ value: String) {
        self.value = value;
        if isOperator(value) {
            self.type = TokenType.Operator
            self.priority = getPriority(value)
        } else if !isNumber(value) {
            print("Debug: ERROR - \(value) значение ни цифра, ни оператор")
        }
    }
    
    func isNumber(_ token: String) -> Bool {
        return Double(token) != nil
    }

    func isOperator(_ token: String) -> Bool {
        let operators = ["+", "-", "×", "÷", "%",]
        return operators.contains(token)
    }
    
    func getPriority(_ token: String) -> Int {
        switch (token) {
        case "+", "-":
            return 0
        case "×", "÷", "%":
            return 1
        default:
            print("Debug: ERROR - Символ не найден: \(token)")
            return 0
        }
    }
    
    func performOperation(_ num1: Double, _ num2: Double) -> Double {
        switch (value) {
        case ("+"):
            return num1 + num2
        case ("-"):
            return num1 - num2
        case ("×"):
            return num1 * num2
        case ("÷"):
            if (num2 == 0) {
                print("Debug: ERROR - Деление на ноль запрещено")
            }
            return num1 / num2
        case ("%"):
            return Double(Int(num1) % Int(num2))
        default:
            print("Debug: ERROR - Не определили значение: \(value)")
            return 0
        }
    }
}
