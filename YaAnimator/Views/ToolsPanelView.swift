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
    private lazy var toolsStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [UIView(), penButton, eraserButton, colorPickerButton, UIView()])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .equalCentering
        sv.spacing = 8
        return sv
    }()
    
    private let colorPickerStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 16
        return sv
    }()
    private let colorPickerContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.layer.masksToBounds = true
        blurEffectView.layer.cornerRadius = 4
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        return view
    }()
    
    private var selectedTool: Tool = .pen {
        didSet {
            updateSelectedTool()
            delegate?.didSelectTool(selectedTool)
        }
    }
    private var selectedColor: ColorPreset = .red {
        didSet {
            updateColorPickerButton()
            delegate?.didSelectColor(selectedColor)
        }
    }
    
    weak var parentVC: UIViewController?
    weak var delegate: ToolsPanelDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        delegate?.didSelectTool(selectedTool)
        updateSelectedTool()
        
        delegate?.didSelectColor(selectedColor)
        updateColorPickerButton()
    }
    
    @objc private func handlePenSelected() {
        selectedTool = .pen
    }
    
    @objc private func handleEraserSelected() {
        selectedTool = .eraser
    }
    
    @objc private func openColorSelectorButtonTapped() {
        parentVC?.showPanelPopover(content: colorPickerContainer, from: toolsStackView)
    }
    
    @objc private func colorTapped(_ sender: UIButton) {
        guard let selectedColorPreset = ColorPreset(rawValue: sender.tag) else { return }
        self.selectedColor = selectedColorPreset
    }
    
    private func setup() {
        addSubview(toolsStackView)
        toolsStackView.backgroundColor = .black
        
        colorPickerContainer.addSubview(colorPickerStackView)
        
        penButton.addTarget(self, action: #selector(handlePenSelected), for: .touchUpInside)
        eraserButton.addTarget(self, action: #selector(handleEraserSelected), for: .touchUpInside)
        colorPickerButton.addTarget(self, action: #selector(openColorSelectorButtonTapped), for: .touchUpInside)
        
        for colorPreset in ColorPreset.allCases {
            let button = UIButton()
            button.setImage(
                UIImage.colorIcon(color: colorPreset.uiColor, isHighlighted: false),
                for: .normal
            )
            button.tag = colorPreset.rawValue
            button.addTarget(self, action: #selector(colorTapped), for: .touchUpInside)
            colorPickerStackView.addArrangedSubview(button)
        }
        
        NSLayoutConstraint.activate([
            toolsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            toolsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            toolsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            toolsStackView.heightAnchor.constraint(equalToConstant: 32),
            toolsStackView.topAnchor.constraint(equalTo: topAnchor),

            colorPickerStackView.centerXAnchor.constraint(equalTo: colorPickerContainer.centerXAnchor),
            colorPickerStackView.leadingAnchor.constraint(greaterThanOrEqualTo: colorPickerContainer.leadingAnchor),
            colorPickerStackView.topAnchor.constraint(equalTo: colorPickerContainer.topAnchor, constant: 16),
            colorPickerStackView.bottomAnchor.constraint(equalTo: colorPickerContainer.bottomAnchor, constant: -16),
            colorPickerStackView.trailingAnchor.constraint(lessThanOrEqualTo: colorPickerContainer.trailingAnchor),
            colorPickerStackView.heightAnchor.constraint(equalToConstant: 32),
        ])
    }
    
    private func updateColorPickerButton() {
        colorPickerButton.setImage(
            UIImage.colorIcon(color: selectedColor.uiColor, isHighlighted: false),
            for: .normal
        )
    }
    
    private func updateSelectedTool() {
        let highlightedButton: UIButton?
        switch selectedTool {
        case .pen:
            highlightedButton = penButton
        case .eraser:
            highlightedButton = eraserButton
        }
        
        [penButton, eraserButton].forEach { button in
            let tintColor: UIColor = highlightedButton == button ? .buttonAccent : .white
            let image = button.image(for: .normal)?.withTintColor(tintColor)
            button.setImage(image, for: .normal)
        }
    }
}
