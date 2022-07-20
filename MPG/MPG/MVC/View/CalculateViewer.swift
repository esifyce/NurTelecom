//
//  CalculateViewer.swift
//  MPG
//
//  Created by Krasivo on 20.07.2022.
//

import UIKit

class CalculateViewer: UIViewController {
    
    // MARK: - Property
    
    var calculateView: CalculateView = CalculateView()
    var controller: CalculateController?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        controller = .init(viewer: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        controller = .init(viewer: self)
    }
    
    // MARK: - Lifecycle VC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Selectors
    
    @objc
    private func totalResults() {
        controller?.calcNumberController()
    }
    
    // MARK: - Configure
    
    private func configure() {
        setupViews()
        setupConstraints()
        setupNotificationTarget()
        
        title = "MPG"
        view.backgroundColor = .white
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
    
    private func setupNotificationTarget() {
        calculateView.calculateButton.addTarget(self, action: #selector(totalResults), for: .touchUpInside)
    }
    
    // MARK: - Helpers
    func update(text: String) {
        calculateView.resultsTextField.text = text
    }
}

