//
//  CustomButton.swift
//  CalculatorMVC
//
//  Created by Krasivo on 17.07.2022.
//

import UIKit

protocol CustomButtonDelegate: AnyObject {
    func addNumber(_ stringNumber: CustomButton.TypeButton)
    func addPoint()
    func displayResault()
    func chooseFunctional(_ function: CustomButton.TypeButton)
    func chooseAdditionalFunctional(_ additionalfunction: CustomButton.TypeButton)
}

class CustomButton: UIView {
    
    // MARK: - Enum
    
    enum TypeButton: String, CaseIterable {
        case deleteState1 = "AC"
        case deleteState2 = "C"
        
        case percent = "%"
        case invertion = "⁺⁄₋"
        case division = "÷"
        
        case seven = "7"
        case eight = "8"
        case nine = "9"
        case multiplay = "×"
        
        case four = "4"
        case five = "5"
        case six = "6"
        case minus = "-"
        
        case one = "1"
        case two = "2"
        case three = "3"
        case plus = "+"
        
        case zero = "0"
        case point = ","
        case equal = "="
        
        var backgroundButtonColor: UIColor {
            switch self {
            case .division, .multiplay, .plus, .minus, .equal: return .systemOrange
            case .deleteState1, .deleteState2, .percent, .invertion: return .systemGray
            default: return .darkGray
            }
        }
        
        var font: UIFont {
            switch self {
            case .division, .multiplay, .minus, .plus, .equal: return .boldSystemFont(ofSize: 35)
            default: return .boldSystemFont(ofSize: 40)
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .deleteState1, .deleteState2, .invertion, .percent: return .black
            default: return .white
            }
        }
    }
    
    // MARK: - Property
    
    private var typeButton: TypeButton?
    weak var delegate: CustomButtonDelegate?
    
    // MARK: - Views
    
    private let backgroundView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleButtonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let calcButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.text = nil
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var text: String? {
        didSet {
            titleButtonLabel.text = text
        }
    }
    
    // MARK: - Init
    
    init(frame: CGRect, typeButton: TypeButton) {
        super.init(frame: frame)
        self.typeButton = typeButton
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle VC
    
    override func layoutSubviews() {
        layer.cornerRadius = frame.height / 2
        backgroundView.layer.cornerRadius = layer.cornerRadius
        
        clipsToBounds = true
    }
    
    // MARK: - Selectors
    @objc
    private func tapButton() {
        playAnimation()
        
        guard let typeButton = typeButton else { return }
        switch typeButton {
        case .point:
            delegate?.addPoint()
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            delegate?.addNumber(typeButton)
        case .equal:
            delegate?.displayResault()
        case .plus, .minus, .multiplay, .division:
            delegate?.chooseFunctional(typeButton)
        case .deleteState1, .deleteState2, .invertion, .percent:
            delegate?.chooseAdditionalFunctional(typeButton)
        }
    }
    
    // MARK: - Configure
    
    private func configure() {
        setupViews()
        setupConstraints()
        setupNotificationTarget()
        
        guard let typeButton = typeButton else { return }
        
        backgroundColor = .white
        
        text = typeButton.rawValue
        titleButtonLabel.font = typeButton.font
        titleButtonLabel.textColor = typeButton.textColor
        
        backgroundView.backgroundColor = typeButton.backgroundButtonColor
        
    }
    
    private func setupViews() {
        addSubview(backgroundView)
        addSubview(titleButtonLabel)
        addSubview(calcButton)
    }
    
    private func setupConstraints() {
        let constraints = [
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            
            titleButtonLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleButtonLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleButtonLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            titleButtonLabel.topAnchor.constraint(equalTo: self.topAnchor),
            
            calcButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            calcButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            calcButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            calcButton.topAnchor.constraint(equalTo: self.topAnchor)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupNotificationTarget() {
        calcButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    }
    
    // MARK: - Helpers
    
    private func playAnimation() {
        let animation = CABasicAnimation(keyPath: "backgroundColor")

        switch typeButton {
        case .division, .multiplay, .minus, .plus, .equal:
            animation.fromValue = UIColor.systemOrange.cgColor
            animation.toValue = UIColor.systemOrange.withAlphaComponent(0.3).cgColor
        case .deleteState1, .invertion, .percent:
            animation.fromValue = UIColor.systemGray.cgColor
            animation.toValue = UIColor.systemGray.withAlphaComponent(0.7).cgColor
        default:
            animation.fromValue = UIColor.systemGray3.cgColor
            animation.toValue = UIColor.systemGray3.withAlphaComponent(0.7).cgColor
        }

        animation.duration = 0.2
        animation.repeatCount = 1
        backgroundView.layer.add(animation, forKey: "backgroundColor")
    }
    
}
