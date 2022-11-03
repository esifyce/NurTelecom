//
//  FontAndSizeViewer.swift
//  NotePad MVC Pattern
//
//  Created by Masaie on 19/8/22.
//

import UIKit

class FontAndSizeViewer: UITableViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet var fontLabel: UILabel!
    
    // MARK: - Public Properties
    
    let fontsList = UIFont.familyNames
    var textViewFont: UIFont!
    var delegate: SettingsDelegate!

    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : fontsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let sizeCell = tableView.dequeueReusableCell(withIdentifier: FontSizeCell.cellIdentifier, for: indexPath) as? FontSizeCell  else { return UITableViewCell() }

            sizeCell.slider.value = Float(textViewFont.pointSize)
            sizeCell.slider.addTarget(self, action: #selector(sliderChange), for: .valueChanged)
            
            return sizeCell
        } else {
            let fontCell = tableView.dequeueReusableCell(withIdentifier: "fontName", for: indexPath)
            var content = fontCell.defaultContentConfiguration()
            content.text = fontsList[indexPath.row]
            fontCell.contentConfiguration = content
            return fontCell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Размер шрифта" : "Название шрифта"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            fontLabel.font = UIFont(name: fontsList[indexPath.row], size: fontLabel.font.pointSize) ?? UIFont()
        }
    }
    
    @IBAction func doneButtonPressed() {
        delegate.setFont(UIFont(name: fontLabel.font.fontName, size: fontLabel.font.pointSize) ?? UIFont())
        dismiss(animated: true)
    }
    
    @objc private func sliderChange(sender: UISlider) {
        fontLabel.font = UIFont(name: fontLabel.font.fontName, size: CGFloat(sender.value))
    }
}
