//
//  ViewController.swift
//  YaAnimator
//
//  Created by Vlad Eliseev on 29.10.2024.
//

import UIKit

class ViewController: UIViewController {
    
    private let canvasView: FrameCanvasView = {
        return FrameCanvasView()
    }()
    
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
    private let undoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "undoIcon"), for: .normal)
        return button
    }()
    private let redoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "redoIcon"), for: .normal)
        return button
    }()
    private lazy var toolsStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [undoButton, redoButton, UIView(), penButton, eraserButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 8
        return sv
    }()
    
//    private var actions: []
    
//    private var selectedTool: Tool = .pen {
//        didSet {
//            canvasView.selectedTool = selectedTool
//        }
//    }
    
    private weak var delegate: ToolsPanelDelegate? // move to comp
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        canvasView.frame = view.bounds
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(canvasView)
        delegate = canvasView // move to comp
        
        view.addSubview(toolsStackView)
        
        penButton.addTarget(self, action: #selector(handlePenSelected), for: .touchUpInside)
        eraserButton.addTarget(self, action: #selector(handleEraserSelected), for: .touchUpInside)
        
        undoButton.addTarget(self, action: #selector(undo), for: .touchUpInside)
        redoButton.addTarget(self, action: #selector(redo), for: .touchUpInside)
        
        toolsStackView.backgroundColor = .black
        
        NSLayoutConstraint.activate([
            toolsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            toolsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            toolsStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func undo() {
        delegate?.undo()
    }
    
    @objc private func redo() {
        delegate?.redo()
    }
    
    @objc private func handlePenSelected() {
        delegate?.didSelectTool(.pen)
    }
    
    
    @objc private func handleEraserSelected() {
        delegate?.didSelectTool(.eraser)
    }
}

protocol ToolsPanelDelegate: AnyObject {
    
    func undo()
    func redo()
    func didSelectTool(_ tool: Tool)
}
