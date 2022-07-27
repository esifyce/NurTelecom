//
//  CalculatorViewController.swift
//  CalculatorMVVM
//
//  Created by Krasivo on 28.07.2022.
//

import UIKit

class CalculatorViewController: UIViewController {

    // MARK: - Property
    
    private var calculateView: CalculatorView
    private var viewModel: CalculatorViewModelProtocol
    
    // MARK: - Init
    
    init(calculateView: CalculatorView = CalculatorView(), viewModel: CalculatorViewModel = CalculatorViewModel()) {
        self.calculateView = calculateView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        calculateView = CalculatorView()
        viewModel = CalculatorViewModel()
        super.init(coder: coder)
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

extension CalculatorViewController: CustomButtonDelegate {
    func addNumber(_ decimalFunction: CustomButton.TypeButton) {
        guard let text = calculateView.checkLabel.text else { return }
        calculateView.checkLabel.text = text + "\(decimalFunction.rawValue)"
    }
    
    func addPoint() {
        guard let text = calculateView.checkLabel.text else { return }
        calculateView.checkLabel.text = text + "."
    }
    
    func displayResault() {
        calculateView.checkLabel.text = viewModel.splitNumber(
            viewModel.calculate (
                calculateView.checkLabel.text?.split(separator: " ") ?? ["0.0"]
            )
        )
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
            calculateView.checkLabel.text = viewModel.invertNumber(calculateView.checkLabel.text ?? "-0")
        case .percent:
            guard let text = calculateView.checkLabel.text else { return }
            calculateView.checkLabel.text = text + " \(additionalFunction.rawValue) "
        default:
            break
        }
    }
}
