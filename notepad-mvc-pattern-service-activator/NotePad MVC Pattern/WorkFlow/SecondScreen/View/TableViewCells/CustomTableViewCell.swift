//
//  CustomTableViewCell.swift
//  NotePad MVC Pattern
//
//  Created by Sabir Myrzaev on 23.08.2022.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    static let id = "CustomTableViewCell"
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
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
        default:
            image = .init(systemName: "doc.fill")
        }
        
        self.cellImageView.image = image
    }
}
