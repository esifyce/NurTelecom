//
//  CustomLabel.swift
//  CalculatorMVC
//
//  Created by Krasivo on 17.07.2022.
//

import UIKit

class CustomLabel: UIView {
    
    // MARK: - Property
    
    var text: String? {
        didSet {
            numberLabel.text = text
        }
    }
    
    // MARK: - Views
    
    private var numberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 100)
        label.textColor = .white
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var windowView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle VC
    
    override func layoutSubviews() {
        configure()
    }
    
    // MARK: - Configure
    
    private func configure() {
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        addSubview(numberLabel)
        addSubview(windowView)
    }
    
    private func setupConstraints() {
        let constraints = [
            windowView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            windowView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            windowView.topAnchor.constraint(equalTo: self.topAnchor),
            windowView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            numberLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            numberLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            numberLabel.topAnchor.constraint(equalTo: self.topAnchor),
            numberLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
