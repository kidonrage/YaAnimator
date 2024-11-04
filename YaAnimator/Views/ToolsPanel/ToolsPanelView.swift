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
    
    private let moreColorsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "paintpalette.fill"), for: .normal)
        button.tintColor = .black
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    private let colorPickerStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.spacing = 16
        return sv
    }()
    
    private var selectedTool: Tool = .pen {
        didSet {
            updateSelectedTool()
            delegate?.didSelectTool(selectedTool)
        }
    }
    private var selectedColor: ColorSelection = .preset(.red) {
        didSet {
            updateColorPickerButton()
            delegate?.didSelectColor(selectedColor.uiColor)
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
        
        delegate?.didSelectColor(selectedColor.uiColor)
        updateColorPickerButton()
    }
    
    @objc private func handlePenSelected() {
        selectedTool = .pen
    }
    
    @objc private func handleEraserSelected() {
        selectedTool = .eraser
    }
    
    @objc private func openColorSelectorButtonTapped() {
        parentVC?.showPanelPopover(content: colorPickerStackView, from: toolsStackView)
    }
    
    @objc private func colorTapped(_ sender: UIButton) {
        guard let selectedColorPreset = ColorPreset(rawValue: sender.tag) else { return }
        self.selectedColor = .preset(selectedColorPreset.uiColor)
    }
    
    @objc private func openColorPicker(_ sender: UIButton) {
        let colorPicker = UIColorPickerViewController()
        colorPicker.title = "Палитра"
        colorPicker.supportsAlpha = false
        colorPicker.delegate = self
        colorPicker.selectedColor = selectedColor.uiColor
        colorPicker.modalPresentationStyle = .popover
        colorPicker.popoverPresentationController?.sourceItem = sender
        parentVC?.present(colorPicker, animated: true)
    }
    
    private func setup() {
        addSubview(toolsStackView)
        toolsStackView.backgroundColor = .black
        
        penButton.addTarget(self, action: #selector(handlePenSelected), for: .touchUpInside)
        eraserButton.addTarget(self, action: #selector(handleEraserSelected), for: .touchUpInside)
        colorPickerButton.addTarget(self, action: #selector(openColorSelectorButtonTapped), for: .touchUpInside)
        
        moreColorsButton.addTarget(self, action: #selector(openColorPicker), for: .touchUpInside)
        
        colorPickerStackView.addArrangedSubview(moreColorsButton)
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

            colorPickerStackView.heightAnchor.constraint(equalToConstant: 32),
        ])
    }
    
    private func updateColorPickerButton() {
        colorPickerButton.setImage(
            UIImage.colorIcon(color: selectedColor.uiColor, isHighlighted: selectedTool == .pen),
            for: .normal
        )
        moreColorsButton.tintColor = .black
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
        
        updateColorPickerButton()
    }
}


// MARK: - ColorSelection
extension ToolsPanelView {
    
    enum ColorSelection {
        
        case preset(UIColor)
        case palette(UIColor)
        
        var uiColor: UIColor {
            switch self {
            case .preset(let uIColor):
                return uIColor
            case .palette(let uIColor):
                return uIColor
            }
        }
    }
}


// MARK: - UIColorPickerViewControllerDelegate
extension ToolsPanelView: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewController(
        _ viewController: UIColorPickerViewController,
        didSelect color: UIColor,
        continuously: Bool
    ) {
        self.selectedColor = .palette(color)
    }
}
