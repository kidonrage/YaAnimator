//
//  ToolsPanelView.swift
//  YaAnimator
//
//  Created by Vlad Eliseev on 02.11.2024.
//

import UIKit

final class ToolsPanelView: UIView {
    
    private let penButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "penIcon"), for: .normal)
        return button
    }()
    private let eraserButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "eraserIcon"), for: .normal)
        return button
    }()
    private let colorPickerButton: UIButton = {
        let button = UIButton()
        return button
    }()
    private let colorPickerContainer: UIView = {
        let view = UIView()
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        return view
    }()
    private lazy var toolsStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [UIView(), penButton, eraserButton, colorPickerButton, UIView()])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .equalCentering
        sv.spacing = 8
        return sv
    }()
}
