//
//  ViewController.swift
//  YaAnimator
//
//  Created by Vlad Eliseev on 29.10.2024.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var canvasView: FrameCanvasView = {
        let view = FrameCanvasView(initialFrame: framesManager.frames[0])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let layersButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "layersIcon"), for: .normal)
        return button
    }()
    private let addFrameButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "addFileIcon"), for: .normal)
        return button
    }()
    private let deleteFrameButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "binIcon"), for: .normal)
        return button
    }()
    private let playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "playIcon"), for: .normal)
        return button
    }()
    private let pauseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "pauseIcon"), for: .normal)
        return button
    }()
    private lazy var topToolsStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            undoButton, redoButton, UIView(), deleteFrameButton, addFrameButton, layersButton, UIView(), pauseButton, playButton
        ])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 8
        return sv
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
        let sv = UIStackView(arrangedSubviews: [UIView(), penButton, eraserButton, UIView()])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .equalCentering
        sv.spacing = 8
        return sv
    }()
    private let backgroundPaperImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "canvasBackground"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let framesManager = FramesManager.shared
    
    private var animationDemoTimer: Timer?
    
    private weak var delegate: ToolsPanelDelegate? // move to comp

    override func viewDidLoad() {
        super.viewDidLoad()
        
        framesManager.delegate = self
        
        view.backgroundColor = .black // TODO: Theme?
        
        view.addSubview(backgroundPaperImageView)
        
        view.addSubview(canvasView)
        delegate = canvasView // move to comp
        canvasView.configure(currentFrame: framesManager.frames[0], previousFrame: nil)
        
        canvasView.delegate = self
        
        view.addSubview(topToolsStackView)
        topToolsStackView.backgroundColor = .black
        
        deleteFrameButton.addTarget(self, action: #selector(deleteFrameTapped), for: .touchUpInside)
        layersButton.addTarget(self, action: #selector(handleLayersTapped), for: .touchUpInside)
        addFrameButton.addTarget(self, action: #selector(handleAddFrameTapped), for: .touchUpInside)
        
        playButton.addTarget(self, action: #selector(play), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pause), for: .touchUpInside)
        
        view.addSubview(toolsStackView)
        toolsStackView.backgroundColor = .black
        
        penButton.addTarget(self, action: #selector(handlePenSelected), for: .touchUpInside)
        eraserButton.addTarget(self, action: #selector(handleEraserSelected), for: .touchUpInside)
        
        undoButton.addTarget(self, action: #selector(undo), for: .touchUpInside)
        redoButton.addTarget(self, action: #selector(redo), for: .touchUpInside)
        
        updateUndoRedoButtons()
        
        NSLayoutConstraint.activate([
            topToolsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topToolsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            topToolsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            topToolsStackView.heightAnchor.constraint(equalToConstant: 40),
            
            canvasView.topAnchor.constraint(equalTo: topToolsStackView.bottomAnchor),
            canvasView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            canvasView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            canvasView.bottomAnchor.constraint(equalTo: toolsStackView.topAnchor),
            
            backgroundPaperImageView.topAnchor.constraint(equalTo: canvasView.topAnchor),
            backgroundPaperImageView.trailingAnchor.constraint(equalTo: canvasView.trailingAnchor),
            backgroundPaperImageView.bottomAnchor.constraint(equalTo: canvasView.bottomAnchor),
            backgroundPaperImageView.leadingAnchor.constraint(equalTo: canvasView.leadingAnchor),
            
            toolsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            toolsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            toolsStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func updateUndoRedoButtons() {
        undoButton.isEnabled = delegate?.isUndoButtonEnabled ?? false
        redoButton.isEnabled = delegate?.isRedoButtonEnabled ?? false
    }
    
    @objc private func play() {
        animationDemoTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] timer in
            guard
                let self,
                let currentFrameIndex = self.framesManager.frames.firstIndex(where: { $0.id == self.framesManager.selectedFrame.id })
            else { return }
            
            let nextFrameIndex = currentFrameIndex < self.framesManager.frames.count - 1
                ? currentFrameIndex + 1
                : 0
            let nextFrame = self.framesManager.frames[nextFrameIndex]
            
            self.framesManager.selectFrame(frame: nextFrame)
            
//            self.canvasView.configure(currentFrame: nextFrame, previousFrame: nil)
        })
    }
    
    @objc private func pause() {
        animationDemoTimer?.invalidate()
    }
    
    @objc private func handleLayersTapped(_ sender: UIButton) {
        let popoverViewController = FramesTableViewController(framesManager: framesManager)
        popoverViewController.delegate = self
        
        popoverViewController.modalPresentationStyle = .popover
        
        // 3. Configure the popover presentation
        let popoverPresentationController = popoverViewController.popoverPresentationController
        // Set the permitted arrow directions
        popoverPresentationController?.permittedArrowDirections = .up
        // Set the source rect (the bounds of the button)
        popoverPresentationController?.sourceRect = sender.bounds
        // Set the source view (the button)
        popoverPresentationController?.sourceView = sender
        // 4. Set the view controller as the delegate to manage the popover's behavior.
        popoverPresentationController?.delegate = self
        
        self.present(popoverViewController, animated: true)
    }
    
    @objc private func deleteFrameTapped() {
        framesManager.deleteCurrentFrame()
    }
    
    @objc private func undo() {
        delegate?.undo()
        updateUndoRedoButtons()
    }
    
    @objc private func redo() {
        delegate?.redo()
        updateUndoRedoButtons()
    }
    
    @objc private func handlePenSelected() {
        delegate?.didSelectTool(.pen)
    }
    
    @objc private func handleEraserSelected() {
        delegate?.didSelectTool(.eraser)
    }
    
    @objc private func handleAddFrameTapped() {
        framesManager.addFrame()
    }
    
    private func updateCanvas(withSelectedFrame frame: Frame) {
        let index = framesManager.frames.firstIndex(where: { $0.id == frame.id }) ?? -1 // todo: Ref
        canvasView.configure(
            currentFrame: frame,
            previousFrame: index > 0 ? framesManager.frames[index - 1] : nil
        )
    }
}

protocol ToolsPanelDelegate: AnyObject {
    
    var isUndoButtonEnabled: Bool { get }
    var isRedoButtonEnabled: Bool { get }
    
    func undo()
    func redo()
    func didSelectTool(_ tool: Tool)
}

extension ViewController: FrameCanvasViewDelegate {
    
    func didUpdateDrawing() {
        updateUndoRedoButtons()
    }
}

extension ViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension ViewController: FramesTableViewControllerDelegate {
    
    func didSelectFrame(frame: Frame) {
        self.framesManager.selectFrame(frame: frame)
        dismiss(animated: true)
    }
}

extension ViewController: FramesManagerDelegate {
    
    func didUpdateSelectedFrame(frame: Frame) {
        updateCanvas(withSelectedFrame: frame)
    }
}
