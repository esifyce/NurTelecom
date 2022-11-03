//
//  String + Extensions.swift
//  NotePad MVC Pattern
//
//  Created by Pavel Epaneshnikov on 08.08.2022.
//

import Foundation

/*
 Метод возвращает расширение файла
    let file = "johnDoe.swift"
    print(file.getExtension()) -> swift
*/

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

extension String {
    func getExtension() -> String {
        let split = self.split(separator: ".", maxSplits: 1)
        return split.last?.description ?? ""
    }
    
    func getName() -> String {
        let split = self.split(separator: ".", maxSplits: 1)
        return split.first?.description ?? ""
    }
    
    var latinCharactersAndNumbersOnly: Bool {
        return self.range(of: ".*[^A-Za-z0-9].*", options: .regularExpression) == nil
    }
    
    func contains(_ strings: [String]) -> Bool {
        strings.contains { contains($0) }
    }
}
