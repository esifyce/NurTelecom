//
//  ResultsCalculate.swift
//  MPG
//
//  Created by Krasivo on 20.07.2022.
//

import Foundation

class ResultsCalculate {
    
    private func splitNumber(_ number: Double) -> String {
      
      // Переводим число Double в String
      let word = String(number)

      // Создаем массив Char
      var char = [Character]()
      
      // Итоговая переменная, куда будем вписывать результат
      var result: String = ""

      // Добавляем слово в массив Char
      for i in word {
        char.append(i)
      }

      // Проходимся по элементам и удаляем десятичные числа в массиве Char и вписываем результат
      for index in (0..<char.count).reversed() {
        let item = char[char.count - 1 - index]
        if item == "." {
          result += ","
            char.remove(at: char.count - 1 - index)
          break
        }
        result += String(item)
        char.remove(at: char.count - 1 - index)
      }

      /// У нас уже есть результат десятичных чисел, добавляем числа после запятой

      //  Если чисел после запятой нет, тогда возвращаем целое число с двумя нулями
      if char == [] {
        return result
      } else if char.count >= 2 {
        result += "\(char[0])\(char[1])"
      } else {
        result += "\(char[0])0"
      }

      // возвращаем результат
      return result
    }

    func totalGasoline(litr: Double, km: Double) -> String {
        return splitNumber(km / litr)
    }
}
