//
//  ButtonsFragmentView.swift
//  NotePad MVC Pattern
//
//  Created by Ulan Beishenkulov on 11/8/22.
//

import UIKit

@IBDesignable
class ButtonsFragmentView: UIView {
    
    @IBOutlet var buttonsView: UIView!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var openFolder: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        buttonsInit()
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buttonsInit()
    }
    
    private func buttonsInit() {
        let bundle = Bundle.init(for: ButtonsFragmentView.self)
        if let addView = bundle.loadNibNamed("ButtonsFragment", owner: self, options: nil), let buttonBack = addView.first as? UIView {
            addSubview(buttonBack)
            buttonBack.frame = self.bounds
            buttonBack.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
    }
    
}
