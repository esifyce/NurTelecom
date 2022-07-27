//
//  ReversePolishNotation.swift
//  CalculatorMVC
//
//  Created by Krasivo on 27.07.2022.
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
        let operators = ["+", "−", "×", "÷", "%",]
        return operators.contains(token)
    }
    
    func getPriority(_ token: String) -> Int {
        switch (token) {
        case "+", "−":
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
        case ("−"):
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

class ReversePolishNotation {
    var numbers: [Token] = []
    var stack: [Token] = []
    
    // Вычисление выражения
    func calculate(_ nums: [String.SubSequence]) -> Double {
        stack.removeAll()
        numbers.removeAll()
        convertInfixToPostfix(nums)
        computePostfixExpression()
        if (stack.count == 1) { // Когда в стэке остается 1 эоемент
            return Double(stack[0].value)!
        } else {
            print("Debug: ERROR - После вычесления в стеке больше одного значения")
            return 0
        }
    }
    
    // извлекает последние 2 числа из стека. Выполняет операцию, а затем добавляет результат обратно в стек
    func performOperationOnStack(_ stack: inout [Token], _ operation: Token) {
        let lastNum: Token = stack.popLast()!
        let secondlastNum: Token = stack.popLast()!
        
        let result: Double = operation.performOperation(Double(secondlastNum.value)!, Double(lastNum.value)!)
        let resultNum = Token(String(result))
        
        stack.append(resultNum);
    }
    
    // преобразование выражения инфиксной нотации в постфиксную
    func convertInfixToPostfix(_ elements: [String.SubSequence]) {
        for i in 0..<elements.count {
            let token: Token = Token(String(elements[i]))
            if token.type == TokenType.Number {
                numbers.append(token)
            } else {
                while stack.count > 0 &&
                    stack.last!.priority >= token.priority {
                        numbers.append(stack.last!)
                        stack.removeLast()
                }
                stack.append(token)
            }
        }
        
        // перемещает стек
        while stack.count > 0 {
            numbers.append(stack.last!)
            stack.removeLast()
        }
    }
    
    // Вычисляет постфиксное выражение
    func computePostfixExpression() {
        for i in 0..<numbers.count {
            numbers[i].type == TokenType.Number ? stack.append(numbers[i]) : performOperationOnStack(&stack, numbers[i])
        }
    }
}
