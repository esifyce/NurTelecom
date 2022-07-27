//
//  CalculatorView.swift
//  CalculatorMVC
//
//  Created by Krasivo on 11.07.2022.
//

import UIKit

class CalculatorView: UIView {
    
    // MARK: - Views
    
    lazy var checkLabel: CustomLabel = {
       let label = CustomLabel()
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var collectionTypeButtons: [[CustomButton.TypeButton]] = [
        [.deleteState1, .invertion, .percent, .division],
        [.seven, .eight, .nine, .multiplay],
        [.four, .five, .six, .minus],
        [.one, .two, .three, .plus],
        [.point, .equal]
    ]
    
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
        
        self.backgroundColor = .black
    }
    
    private func setupViews() {
        self.addSubview(checkLabel)
        self.addSubview(mainStackView)
    }
    
    private func setupConstraints() {
        let constraints = [
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            mainStackView.heightAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 1.25),
            
            checkLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            checkLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            checkLabel.bottomAnchor.constraint(equalTo: mainStackView.topAnchor, constant: -16),
            checkLabel.heightAnchor.constraint(equalToConstant: 100)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
