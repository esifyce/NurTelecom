//
//  CustomCollectionViewCell.swift
//  NotePad MVC Pattern
//
//  Created by Sabir Myrzaev on 23.08.2022.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {

    static let id = "CustomCollectionViewCell"

    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!

    func updateData(element: Element, selected: Bool) {
        updateImage(element: element)
        
        self.cellLabel.text = element.name
        
        self.backgroundColor = selected ? .yellow : .clear
    }

    private func updateImage(element: Element) {
        let image: UIImage?

        switch element.type {
        case .folder:
            image = .init(systemName: "folder.fill")
        case .swift:
            image = .init(named: "swift")
        case .kt:
            image = .init(named: "kt")
        case .java:
            image = .init(named: "java")
        case .ntp:
            image = .init(named: "notepad")
        case .unknown:
            image = .init(named: "unknown")

        }
        self.cellImageView.image = image
    }
}
