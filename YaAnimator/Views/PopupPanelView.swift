//
//  PopupPanelView.swift
//  YaAnimator
//
//  Created by Vlad Eliseev on 02.11.2024.
//

import UIKit

final class PopupPanelView: UIView {
    
    private let testPanelView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.layer.masksToBounds = true
        blurEffectView.layer.cornerRadius = 4
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.isUserInteractionEnabled = true
        return view
    }()
    private let contentView: UIView
    private let anchorView: UIView
    
    private var isDismissing: Bool = false
    
    weak var presentingViewController: UIViewController?
    
    init(
        contentView: UIView,
        anchorView: UIView,
        presentingViewController: UIViewController
    ) {
        self.contentView = contentView
        self.presentingViewController = presentingViewController
        self.anchorView = UIView(
            frame: anchorView.superview?.convert(
                anchorView.frame, to: presentingViewController.view
            ) ?? .zero
        )
        
        super.init(frame: .zero)
        
        setup()
    }
    
    private func setup() {
        addSubview(testPanelView)
        addSubview(contentView)
        addSubview(anchorView)
        
        anchorView.backgroundColor = .red
        
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: anchorView.centerXAnchor),
            contentView.bottomAnchor.constraint(equalTo: anchorView.topAnchor, constant: -8),
            
            testPanelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            testPanelView.topAnchor.constraint(equalTo: contentView.topAnchor),
            testPanelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            testPanelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("[TEST] tb")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if testPanelView.frame.contains(point) {
            return super.hitTest(point, with: event)
        }
        
        self.dismiss()
        
        return nil
    }
    
    private func dismiss() {
        guard !isDismissing else { return }
        isDismissing = true
        UIView.animate(
            withDuration: 0.1,
            animations: {
                self.alpha = 0.0
            },
            completion: { [weak self] isFinished in
                guard isFinished else { return }
                self?.removeFromSuperview()
            }
        )
    }
}

extension UIViewController {
    
    func showPanelPopover(content: UIView, from anchorView: UIView) {
        let panel = PopupPanelView(contentView: content, anchorView: anchorView, presentingViewController: self)
        panel.alpha = 0.0
        panel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(panel)
        
        NSLayoutConstraint.activate([
            panel.topAnchor.constraint(equalTo: view.topAnchor),
            panel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            panel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            panel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        UIView.animate(withDuration: 0.1) {
            panel.alpha = 1.0
        }
    }
}
