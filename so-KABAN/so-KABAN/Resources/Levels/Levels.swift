//
//  Levels.swift
//  so-KABAN
//
//  Created by Krasivo on 29.09.2022.
//

import Foundation

// 0 - space
// 1 - player
// 2 - wall
// 3 - box
// 4 - target

public final class Levels {
    
    // MARK: - Property
    
    fileprivate let client: Client
    
    // MARK: - Init
    
    init() {
        client = Client()
    }
}

// MARK: - fileprivate Levels methods

fileprivate extension Levels {
        
    // MARK: - Parsing File
    
    func parsingFile(level: Int) -> [[Int]] {
        let filePath = Bundle.main.path(forResource: "Level\(level)", ofType: "sok")
        var data = ""
        do {
            data = try String(contentsOfFile: filePath!, encoding: .utf8)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        data = data.filter {
            $0.isNumber || $0.isNewline
        }
        var map = [[Int]]()
        var subarray = [Int]()
        data += " "
        for i in data {
            if let int = Int(String(i)) {
                subarray.append(int)
            } else if i.isWhitespace && subarray.count != 0 {
                map.append(subarray)
                subarray = []
            }
        }
        return map
    }
    
    // MARK: - Parsing Server
    
    func parsingServer(map: String) -> [[Int]] {
        var row = 0
        var column = 0
        var indexRow = 0
        var array = [[Int]]()
        
        for i in map where i == "A" {
            row = row + 1
        }
         array = Array(repeating: [], count: row)

        for i in map {
            if i == "A" {
                array[indexRow] = Array(repeating: 0, count: column)
                indexRow = indexRow + 1
                column = 0
            } else {
                column = column + 1
            }
        }
        row = 0
        column = 0
        
        for i in map {
            if i == "A" {
                row = row + 1
                column = 0
            } else {
                let number = Int(String(i))
                array[row][column] = number!
                column = column + 1
            }
        }
        return array
    }
}

// MARK: - public Levels methods

public extension Levels {
    func getFirstLevel() -> [[Int]] {
        return [
            [2, 2, 2, 2, 2, 2, 2, 2],
            [2, 0, 0, 0, 0, 0, 0, 2],
            [2, 0, 3, 0, 2, 0, 0, 2],
            [2, 0, 2, 0, 0, 4, 0, 2],
            [2, 0, 0, 0, 0, 2, 0, 2],
            [2, 0, 0, 2, 0, 0, 0, 2],
            [2, 0, 1, 0, 0, 0, 0, 2],
            [2, 2, 2, 2, 2, 2, 2, 2]
        ]
    }
    
    func getSecondLevel() -> [[Int]] {
        return [
            [2, 2, 2, 2, 2, 2, 2, 2],
            [2, 0, 0, 0, 0, 0, 0, 2],
            [2, 0, 3, 0, 0, 2, 0, 2],
            [2, 0, 2, 0, 0, 4, 0, 2],
            [2, 0, 0, 0, 0, 2, 0, 2],
            [2, 0, 3, 2, 4, 0, 0, 2],
            [2, 0, 1, 0, 0, 0, 0, 2],
            [2, 2, 2, 2, 2, 2, 2, 2]
        ]
    }
    
    func getThirdLevel() -> [[Int]] {
        return [
            [2, 2, 2, 2, 2, 2, 2, 2],
            [2, 0, 0, 0, 0, 4, 4, 2],
            [2, 0, 3, 0, 0, 2, 0, 2],
            [2, 2, 2, 0, 0, 2, 0, 2],
            [2, 0, 0, 0, 0, 0, 0, 2],
            [2, 0, 3, 2, 0, 2, 0, 2],
            [2, 2, 1, 0, 0, 0, 0, 2],
            [2, 2, 2, 2, 2, 2, 2, 2]
        ]
    }
    
    func getFourthLevel() -> [[Int]] {
        return parsingFile(level: 4)
    }
    
    func getFifthLevel() -> [[Int]] {
        return parsingFile(level: 5)
    }
     
    func getSixthLevel() -> [[Int]] {
        return parsingFile(level: 6)
    }
    
    func getSeventhLevel() -> [[Int]] {
        return parsingServer(map: client.getDesktopFromServer(message: "level7"))
    }
    
    func getEigthLevel() -> [[Int]] {
        return parsingServer(map: client.getDesktopFromServer(message: "level8"))
    }
    
    func getNinthLevel() -> [[Int]] {
        return parsingServer(map: client.getDesktopFromServer(message: "level9"))
    }
    
    func getLevel(number: Int) -> [[Int]] {
        switch number {
        case 1:
            return getFirstLevel()
        case 2:
            return getSecondLevel()
        case 3:
            return getThirdLevel()
        case 4:
            return getFourthLevel()
        case 5:
            return getFifthLevel()
        case 6:
            return getSixthLevel()
        case 7:
            return getSeventhLevel()
        case 8:
            return getEigthLevel()
        case 9:
            return getNinthLevel()
        default:
            return getFirstLevel()
        }
    }
}


