//
//  UIStackView + Extension.swift
//  CalculatorMVC
//
//  Created by Krasivo on 11.07.2022.
//

import UIKit

extension Array where Element == UIView {
    func toStackView(orientation: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .fill, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: self)
        stackView.axis = orientation
        stackView.distribution = distribution
        stackView.spacing = spacing
        stackView.alignment = alignment
        return stackView
    }
}
