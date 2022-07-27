//
//  MPGConverter.swift
//  CalculatorMVC
//
//  Created by Krasivo on 27.07.2022.
//

import Foundation

class MPGConverter {
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
}
