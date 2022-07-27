//
//  CalculatorViewer.swift
//  CalculatorMVC
//
//  Created by Krasivo on 11.07.2022.
//

import UIKit

class CalculatorViewer: UIViewController {
    
    // MARK: - Property
    
    var calculateView: CalculatorView
    var controller: CalculatorController?
    
    // MARK: - Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        calculateView = CalculatorView()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        controller = .init(viewer: self)
    }
    
    required init?(coder: NSCoder) {
        calculateView = CalculatorView()
        super.init(coder: coder)
        controller = .init(viewer: self)
    }
    
    // MARK: - Lifecycle VC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        calculateView.checkLabel.text = ""
    }
    
    // MARK: - Configure
    
    private func configureUI() {
        setupViews()
        setupConstraints()
        
        for item in calculateView.collectionTypeButtons {
            let newStackView = UIStackView()
            newStackView.axis = .horizontal
            newStackView.distribution = .fillEqually
            newStackView.spacing = 10
            
            if item == calculateView.collectionTypeButtons.last {
                let zeroButton = CustomButton(frame: .zero, typeButton: .zero)
                zeroButton.delegate = self
                newStackView.addArrangedSubview(zeroButton)
                
                let pointAndReceiveStackView = UIStackView()
                pointAndReceiveStackView.axis = .horizontal
                pointAndReceiveStackView.distribution = .fillEqually
                pointAndReceiveStackView.spacing = 10
                
                newStackView.addArrangedSubview(zeroButton)
                newStackView.addArrangedSubview(pointAndReceiveStackView)
                
                for button in item {
                    let customButton = CustomButton(frame: .zero, typeButton: button)
                    customButton.delegate = self
                    pointAndReceiveStackView.addArrangedSubview(customButton)
                }
            } else {
                for button in item {
                    let customButton = CustomButton(frame: .zero, typeButton: button)
                    customButton.delegate = self
                    newStackView.addArrangedSubview(customButton)
                }
            }
            calculateView.mainStackView.addArrangedSubview(newStackView)
        }
    }
    
    private func setupViews() {
        view.addSubview(calculateView)
    }
    
    private func setupConstraints() {
        let constraints = [
            calculateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calculateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calculateView.topAnchor.constraint(equalTo: view.topAnchor),
            calculateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Helpers
    
    func updateLabel(text: String) {
        calculateView.checkLabel.text = text
    }
}

// MARK: - CustomButtonDelegate

extension CalculatorViewer: CustomButtonDelegate {
    func addNumber(_ decimalFunction: CustomButton.TypeButton) {
        guard let text = calculateView.checkLabel.text else { return }
        calculateView.checkLabel.text = text + "\(decimalFunction.rawValue)"
    }
    
    func addPoint() {
        guard let text = calculateView.checkLabel.text else { return }
        calculateView.checkLabel.text = text + "."
    }
    
    func displayResault() {
        controller?.finalExpression()
    }
    
    func chooseFunctional(_ mathFunction: CustomButton.TypeButton) {
        guard let text = calculateView.checkLabel.text else { return }
        calculateView.checkLabel.text = text + " \(mathFunction.rawValue) "
    }
    
    func chooseAdditionalFunctional(_ additionalFunction: CustomButton.TypeButton) {
        switch additionalFunction {
        case .deleteState1:
            calculateView.checkLabel.text = ""
        case .invertion:
            var invert = calculateView.checkLabel.text ?? "−0"
            if Double(invert)?.sign == .minus {
                invert.removeFirst()
                calculateView.checkLabel.text = invert
            } else {
                calculateView.checkLabel.text = "−\(invert)"
            }
        case .percent:
            guard let text = calculateView.checkLabel.text else { return }
            calculateView.checkLabel.text = text + " \(additionalFunction.rawValue) "
        default:
            break
        }
    }
}
