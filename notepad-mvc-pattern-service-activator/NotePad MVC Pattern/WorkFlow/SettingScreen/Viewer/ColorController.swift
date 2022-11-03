//
//  ViewAndTextColorViewer.swift
//  NotePad MVC Pattern
//
//  Created by Masaie on 17/8/22.
//

import UIKit

class ColorController: UIViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var colorView: UIView!

    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!

    @IBOutlet weak var redTextField: UITextField!
    @IBOutlet weak var greenTextField: UITextField!
    @IBOutlet weak var blueTextField: UITextField!

    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    // MARK: - Public Properties
    
    var color: UIColor!
    var delegate: SettingsDelegate!
    
    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorView.layer.cornerRadius = 15
        
        redSlider.minimumTrackTintColor = .red
        greenSlider.minimumTrackTintColor = .green
        
        colorView.backgroundColor = color
        
        setSliders()
        setValue(for: redLabel, greenLabel, blueLabel)
        setValue(for: redTextField, greenTextField, blueTextField)
    }
    
    // MARK: - IB Actions
    
    @IBAction func toolbarItem(_ sender: UIBarButtonItem) {
        view.endEditing(true)
    }
    
    @IBAction func rgbSlider(_ sender: UISlider) {
        switch sender {
        case redSlider:
            setValue(for: redLabel)
            setValue(for: redTextField)
        case greenSlider:
            setValue(for: greenLabel)
            setValue(for: greenTextField)
        default:
            setValue(for: blueLabel)
            setValue(for: blueTextField)
        }
        setColor()
    }
    
    @IBAction func doneButtonPressed() {
        delegate.setColor(colorView.backgroundColor ?? .white)
        dismiss(animated: true)
    }
    
    // MARK: - Private Methods
    
    private func setColor() {
        colorView.backgroundColor = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1
        )
    }
    
    private func setValue (for labels: UILabel...) {
        labels.forEach { label in
            switch label {
            case redLabel:
                redLabel.text = string(from: redSlider)
            case greenLabel:
                greenLabel.text = string(from: greenSlider)
            default:
                blueLabel.text = string(from: blueSlider)
            }
        }
    }
    
    private func setValue (for textFields: UITextField...) {
        textFields.forEach { textField in
            switch textField {
            case redTextField:
                redTextField.text = string(from: redSlider)
            case greenTextField:
                greenTextField.text = string(from: greenSlider)
            default:
                blueTextField.text = string(from: blueSlider)
            }
        }
    }
    
    private func setSliders() {
        let ciColor = CIColor(color: color)
        
        redSlider.value = Float(ciColor.red)
        greenSlider.value = Float(ciColor.green)
        blueSlider.value = Float(ciColor.blue)
    }
    
    private func string(from slider: UISlider) -> String {
        String(format:"%.2f", slider.value)
    }
    
    @objc private func didTapDone() {
        view.endEditing(true)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Готово", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension ColorController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        guard let currentValue = Float(text) else { return }

        if currentValue <= 1 && currentValue >= 0 {
            switch textField {
            case redTextField:
                redSlider.setValue(currentValue, animated: true)
                setValue(for: redLabel)
            case greenTextField:
                greenSlider.setValue(currentValue, animated: true)
                setValue(for: greenLabel)
            default:
                blueSlider.setValue(currentValue, animated: true)
                setValue(for: blueLabel)
            }
            
            setColor()
            return
        }
        showAlert(title: "Не верный формат!", message: "Пожалуйста, введите верное значение")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        textField.inputAccessoryView = keyboardToolbar
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(didTapDone)
        )
        
        let flexBarButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        keyboardToolbar.items = [flexBarButton, doneButton]
    }
}

