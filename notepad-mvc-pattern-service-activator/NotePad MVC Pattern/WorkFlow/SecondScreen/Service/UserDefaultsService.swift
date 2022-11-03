//
//  UserDefaultsService.swift
//  NotePad MVC Pattern
//
//  Created by Sabir Myrzaev on 23.08.2022.
//

import Foundation
import UIKit

enum UserDefaultsKey: String {
    case indexOfDisplayMode
    case displayMode
    case tableViewSegment
    case collectionViewSegment
}

class UserDefaultsService {
    private init() { }
    
    static let shared = UserDefaultsService()
    
    func saveSegmentControl(segmentControlIndex: Int) {
        UserDefaults.standard.set(segmentControlIndex, forKey: UserDefaultsKey.indexOfDisplayMode.rawValue)
        
        switch UserDefaults.standard.string(forKey: UserDefaultsKey.displayMode.rawValue) {
        case "Таблица":
            UserDefaults.standard.set(false, forKey: UserDefaultsKey.tableViewSegment.rawValue)
            UserDefaults.standard.set(true, forKey: UserDefaultsKey.collectionViewSegment.rawValue)
        case "Коллекция":
            UserDefaults.standard.set(false, forKey: UserDefaultsKey.collectionViewSegment.rawValue)
            UserDefaults.standard.set(true, forKey: UserDefaultsKey.tableViewSegment.rawValue)
        default:
            return
        }
    }
    
    func saveTextAttributes(fileName: String, color: UIColor, font: UIFont) {
        let attributes = [
            "font": font,
            "color": color
        ]
        
        let data = NSKeyedArchiver.archivedData(withRootObject: attributes)
        UserDefaults.standard.set(data, forKey: fileName)
    }
    
    func getTextAtributes(fileName: String) -> Any? {
        if let data = UserDefaults.standard.value(forKey: fileName) {
            if let dict = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) {
                return dict
            }
        }
        return nil
    }
}
