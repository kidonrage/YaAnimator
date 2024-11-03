//
//  AnimationSpeedSliderView.swift
//  YaAnimator
//
//  Created by Vlad Eliseev on 04.11.2024.
//

import UIKit

final class AnimationSpeedSliderView: UIView {
    
    private let minValueLabel = UILabel()
    private let maxValueLabel = UILabel()
    private let slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 24
        slider.minimumTrackTintColor = .buttonAccent
        return slider
    }()
    private lazy var container: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [minValueLabel, slider, maxValueLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.distribution = .fill
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 8
        return sv
    }()
    
    weak var delegate: AnimationSpeedSliderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubviews(container)
        
        slider.addTarget(self, action: #selector(demoAnimationSpeedSliderValueDidChanged), for: .valueChanged)
        slider.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        minValueLabel.text = "1 FPS"
        minValueLabel.textColor = .white
        maxValueLabel.text = "24 FPS"
        maxValueLabel.textColor = .white
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])
    }
    
    @objc private func demoAnimationSpeedSliderValueDidChanged(_ sender: UISlider) {
        delegate?.didUpdateSpeed(sender.value)
    }
}

protocol AnimationSpeedSliderViewDelegate: AnyObject {
    
    func didUpdateSpeed(_ speed: Float)
}
