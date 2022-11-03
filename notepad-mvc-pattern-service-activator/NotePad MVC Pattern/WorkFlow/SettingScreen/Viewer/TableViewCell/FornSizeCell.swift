//
//  FornSizeCell.swift
//  NotePad MVC Pattern
//
//  Created by Masaie on 17/8/22.
//

import UIKit

class FontSizeCell: UITableViewCell {

    @IBOutlet var smallCharLabel: UILabel!
    @IBOutlet var largeCharLabel: UILabel!
    @IBOutlet var slider: UISlider! {
        didSet {
            slider.maximumValue = 25
            slider.minimumValue = 1
        }
    }
    
    static let cellIdentifier = "fontSize"
    static let cellNib = UINib(nibName: "fontSize", bundle: Bundle.main)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setSlider()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func sliderAction(_ sender: UISlider) {
        
    }
    
    private func setSlider() {
        
    }

}
