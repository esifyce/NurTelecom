//
//  CalculatorViewModel.swift
//  CalculatorMVVM
//
//  Created by Krasivo on 28.07.2022.
//

import Foundation

protocol CalculatorViewModelProtocol {
    func calculate(_ nums: [String.SubSequence]) -> Double
    func splitNumber(_ number: Double) -> String
    func invertNumber(_ invert: String) -> String
}

class CalculatorViewModel: CalculatorViewModelProtocol {
    
    // MARK: - Property
    
    private var numbers: [Token] = []
    private var stack: [Token] = []
    
    // MARK: - Helpers
    
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
    private func performOperationOnStack(_ stack: inout [Token], _ operation: Token) {
        let lastNum: Token = stack.popLast()!
        let secondlastNum: Token = stack.popLast()!
        
        let result: Double = operation.performOperation(Double(secondlastNum.value)!, Double(lastNum.value)!)
        let resultNum = Token(String(result))
        
        stack.append(resultNum);
    }
    
    // преобразование выражения инфиксной нотации в постфиксную
    private func convertInfixToPostfix(_ elements: [String.SubSequence]) {
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
    private func computePostfixExpression() {
        for i in 0..<numbers.count {
            numbers[i].type == TokenType.Number ? stack.append(numbers[i]) : performOperationOnStack(&stack, numbers[i])
        }
    }
    
    func splitNumber(_ number: Double) -> String {
      
      // Переводим число Double в String и преобразуем массив в Char
      let word = String(number)

      // Итоговая переменная, куда будем вписывать результат
      var result: String = ""

      // переменная для поиска точки в числе
      var point = -1

      // Проходимся по элементам и вписываем результат
      for (index, value) in word.enumerated() {
        if value == "." {
          result += "."
          point = index
          break
        }
        result += String(value)
      }
      
      // получаем первое число после запятой
      let firstIndexAfterDot = word.index(word.startIndex, offsetBy: point + 1)
        // получаем второе число после запятой
      let secondIndexAfterDot = word.index(word.startIndex, offsetBy: point + 2)

      if word.count == result.count {
        return result
      } else if word.count == result.count + 1 {
        result += "\(word[firstIndexAfterDot])0"
      } else {
        result += "\(word[firstIndexAfterDot])\(word[secondIndexAfterDot])"
      }
      return result
    }
    
    func invertNumber(_ invert: String) -> String {
        var changeInvert = invert
        if Double(changeInvert)?.sign == .minus {
            changeInvert.removeFirst()
            return changeInvert
        } else {
            return "-\(changeInvert)"
        }
    }
    
}
