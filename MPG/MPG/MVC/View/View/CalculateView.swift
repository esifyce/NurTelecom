//
//  CalculateView.swift
//  MPG
//
//  Created by Krasivo on 20.07.2022.
//

import UIKit

class CalculateView: UIView {

    // MARK: - Views
    
    let litrLabel: UILabel = {
        let label = UILabel()
        label.text = "Litres:"
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let litrTextField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Введите количество"
        tf.textAlignment = .center
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.keyboardType = .asciiCapableNumberPad
        return tf
    }()
    
    let kmLabel: UILabel = {
        let label = UILabel()
        label.text = "KM:"
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let kmTextField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Введите количество"
        tf.textAlignment = .center
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.keyboardType = .asciiCapableNumberPad
        return tf
    }()
    
    let resultsLabel: UILabel = {
        let label = UILabel()
        label.text = "Results:"
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let resultsTextField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Результат"
        tf.isEnabled = false
        tf.textAlignment = .center
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let calculateButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .purple
        button.setTitle("CALCULATE", for: .normal)
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Configure
    
    private func configure() {
        
        setupViews()
        setupConstraints()
        setupNotificationTarget()
    }
    
    private func setupViews() {
       addSubview(litrLabel)
       addSubview(litrTextField)
       addSubview(kmLabel)
       addSubview(kmTextField)
       addSubview(resultsLabel)
       addSubview(resultsTextField)
       addSubview(calculateButton)
    }
    
    private func setupConstraints() {
        let constraints = [
            litrLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            litrLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 100),
            litrLabel.widthAnchor.constraint(equalToConstant: 100),
            
            litrTextField.leadingAnchor.constraint(equalTo: litrLabel.trailingAnchor, constant: 30),
            litrTextField.centerYAnchor.constraint(equalTo: litrLabel.centerYAnchor),
            litrTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            
            kmLabel.topAnchor.constraint(equalTo: litrLabel.bottomAnchor, constant: 50),
            kmLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            kmLabel.widthAnchor.constraint(equalToConstant: 100),
            
            kmTextField.leadingAnchor.constraint(equalTo: kmLabel.trailingAnchor, constant: 30),
            kmTextField.centerYAnchor.constraint(equalTo: kmLabel.centerYAnchor),
            kmTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            
            resultsLabel.topAnchor.constraint(equalTo: kmLabel.bottomAnchor, constant: 50),
            resultsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            resultsLabel.widthAnchor.constraint(equalToConstant: 100),
            
            resultsTextField.leadingAnchor.constraint(equalTo: resultsLabel.trailingAnchor, constant: 30),
            resultsTextField.centerYAnchor.constraint(equalTo: resultsLabel.centerYAnchor),
            resultsTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            
            calculateButton.topAnchor.constraint(equalTo: resultsLabel.bottomAnchor, constant: 50),
            calculateButton.widthAnchor.constraint(equalToConstant: 60),
            calculateButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            calculateButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupNotificationTarget() {
        
    }
}

