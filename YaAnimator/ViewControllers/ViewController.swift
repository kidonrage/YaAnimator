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
    private lazy var historyManagementPanel: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [undoButton, redoButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 8
        return sv
    }()
    
    private lazy var frameManagementPanel: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [deleteFrameButton, addFrameButton, layersButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 8
        return sv
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
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
    private lazy var playPausePanel: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [shareButton, pauseButton, playButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.distribution = .fillEqually
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.spacing = 8
        return sv
    }()
    
    private lazy var topToolsStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            historyManagementPanel, UIView(), frameManagementPanel , UIView(), playPausePanel
        ])
        sv.distribution = .equalCentering
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 8
        return sv
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
    private let previousFrameImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "canvasBackground"))
        imageView.layer.opacity = 0.3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let backgroundPaperImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "canvasBackground"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let toolsPanelView: ToolsPanelView = {
        let view = ToolsPanelView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let demoAnimationSpeedContainer: AnimationSpeedSliderView = {
        let view = AnimationSpeedSliderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let framesManager = FramesManager.shared
    private let animationDemoManager = AnimationDemoManager()
    private let gifService = GifService()
    
    private weak var delegate: ActionsPanelDelegate? // move to comp

    override func viewDidLoad() {
        super.viewDidLoad()
        
        framesManager.delegate = self
        animationDemoManager.delegate = self
        
        view.backgroundColor = .black // TODO: Theme?
        
        view.addSubview(backgroundPaperImageView)
        view.addSubview(previousFrameImageView)
        
        view.addSubview(canvasView)
        delegate = canvasView // move to comp
        canvasView.configure(currentFrame: framesManager.frames[0], previousFrame: nil)
        canvasView.delegate = self
        
        view.addSubview(topToolsStackView)
        
        view.addSubview(toolsPanelView)
        toolsPanelView.delegate = canvasView
        toolsPanelView.parentVC = self
        
        view.addSubview(demoAnimationSpeedContainer)
        demoAnimationSpeedContainer.delegate = self
        
        deleteFrameButton.addTarget(self, action: #selector(deleteFrameTapped), for: .touchUpInside)
        let deleterameMenu = UIMenu(children: [
            UIAction(title: "Удалить текущий кадр", handler: { [weak self] action in
                self?.deleteFrameTapped()
            }),
            UIAction(title: "Удалить все кадры", handler: { [weak self] action in
                self?.framesManager.deleteAllFrames()
            }),
        ])
        deleteFrameButton.menu = deleterameMenu
        layersButton.addTarget(self, action: #selector(handleLayersTapped), for: .touchUpInside)
        addFrameButton.addTarget(self, action: #selector(handleAddFrameTapped), for: .touchUpInside)
        let addFrameMenu = UIMenu(children: [
            UIAction(title: "Добавить пустой кадр", handler: { [weak self] action in
                self?.handleAddFrameTapped()
            }),
            UIAction(title: "Скопировать кадр", handler: { [weak self] action in
                self?.handleCopyFrameTapped()
            }),
            UIAction(title: "Сгенерировать кадры", handler: { [weak self] action in
                self?.handleGenerateFramesTapped()
            })
        ])
        addFrameButton.menu = addFrameMenu
        
        shareButton.addTarget(self, action: #selector(shareGif), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(play), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pause), for: .touchUpInside)
        
        undoButton.addTarget(self, action: #selector(undo), for: .touchUpInside)
        redoButton.addTarget(self, action: #selector(redo), for: .touchUpInside)
        
        updateUndoRedoButtons()
        
        updateIsControlsHidden(false)
        didEndAnimationPlaying()
        
        NSLayoutConstraint.activate([
            topToolsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topToolsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            topToolsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            topToolsStackView.heightAnchor.constraint(equalToConstant: 32),
            
            canvasView.topAnchor.constraint(equalTo: topToolsStackView.bottomAnchor, constant: 16),
            canvasView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            canvasView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            canvasView.bottomAnchor.constraint(equalTo: toolsPanelView.topAnchor, constant: -16),
            
            backgroundPaperImageView.topAnchor.constraint(equalTo: canvasView.topAnchor),
            backgroundPaperImageView.trailingAnchor.constraint(equalTo: canvasView.trailingAnchor),
            backgroundPaperImageView.bottomAnchor.constraint(equalTo: canvasView.bottomAnchor),
            backgroundPaperImageView.leadingAnchor.constraint(equalTo: canvasView.leadingAnchor),
            
            previousFrameImageView.topAnchor.constraint(equalTo: canvasView.topAnchor),
            previousFrameImageView.trailingAnchor.constraint(equalTo: canvasView.trailingAnchor),
            previousFrameImageView.bottomAnchor.constraint(equalTo: canvasView.bottomAnchor),
            previousFrameImageView.leadingAnchor.constraint(equalTo: canvasView.leadingAnchor),
            
            toolsPanelView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor),
            toolsPanelView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolsPanelView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            toolsPanelView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
            demoAnimationSpeedContainer.topAnchor.constraint(equalTo: toolsPanelView.topAnchor),
            demoAnimationSpeedContainer.trailingAnchor.constraint(equalTo: toolsPanelView.trailingAnchor),
            demoAnimationSpeedContainer.bottomAnchor.constraint(equalTo: toolsPanelView.bottomAnchor),
            demoAnimationSpeedContainer.leadingAnchor.constraint(equalTo: toolsPanelView.leadingAnchor),
        ])
    }
    
    private func updateUndoRedoButtons() {
        undoButton.isEnabled = delegate?.isUndoButtonEnabled ?? false
        redoButton.isEnabled = delegate?.isRedoButtonEnabled ?? false
    }
    
    @objc private func play() {
        animationDemoManager.startAnimation(
            frames: framesManager.frames, selectedFrame: framesManager.selectedFrame
        )
    }
    
    @objc private func pause() {
        animationDemoManager.stopAnimation()
    }
    
    @objc private func shareGif() {
        self.gifService.saveGif(
            fromFrames: framesManager.frames, 
            fps: animationDemoManager.fps
        ) { [weak self] gifURL in
            DispatchQueue.main.async {
                guard let gifURL else {
                    self?.showMessageWithOk(title: "Что-то пошло не так", message: nil)
                    return
                }
                
                let activityViewController = UIActivityViewController(
                    activityItems: [gifURL], applicationActivities: nil
                )
                self?.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
    
    @objc private func handleLayersTapped(_ sender: UIButton) {
        let popoverViewController = FramesTableViewController(framesManager: framesManager)
        popoverViewController.delegate = self
        popoverViewController.modalPresentationStyle = .popover
        
        let popoverPresentationController = popoverViewController.popoverPresentationController
        popoverPresentationController?.permittedArrowDirections = .up
        popoverPresentationController?.sourceRect = sender.bounds
        popoverPresentationController?.sourceView = sender
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
    
    @objc private func handleAddFrameTapped() {
        framesManager.addFrame()
    }
    
    @objc private func handleCopyFrameTapped() {
        canvasView.copyCanvasContentToNewFrame()
    }
    
    private func handleGenerateFramesTapped() {
        let alertController = UIAlertController(title: "Введите количество кадров", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "10"
        }
        
        alertController.addAction(UIAlertAction(title: "Сгенерировать", style: .default, handler: { [weak self] _ in
            guard
                let numberString = alertController.textFields?.first?.text,
                let number = Int(numberString)
            else {
                return
            }
            self?.generateFrames(count: number)
        }))
        alertController.addAction(UIAlertAction(title: "Отмена", style: .default))
        
        present(alertController, animated: true)
    }
    
    private func generateFrames(count: Int) {
        let spinner = showSpinnerView()
        let generator = FramesGenerator()
        generator.generateExampleFrames(count: count, canvasSize: canvasView.frame.size) { generatedFrames in
            DispatchQueue.main.async {
                self.framesManager.addFrames(generatedFrames)
                spinner.hide()
            }
        }
    }
    
    private func updateCanvas(withSelectedFrame frame: Frame) {
        // TODO: Refactor this mess, ideally move previousFrameImageView to CanvasView
        if 
            let index = framesManager.frames.firstIndex(where: { $0.id == frame.id }),
            index > 0,
            let prevFrameImageData = try? Data(contentsOf: framesManager.frames[index - 1].frameSource)
        {
            self.previousFrameImageView.image = UIImage(data: prevFrameImageData)
        } else {
            self.previousFrameImageView.image = nil
        }
        
        canvasView.configure(
            currentFrame: frame,
            previousFrame: nil
        )
    }
}

// MARK: - FrameCanvasViewDelegate
extension ViewController: FrameCanvasViewDelegate {
    
    func didUpdateDrawing() {
        updateUndoRedoButtons()
    }
}

// MARK: - UIPopoverPresentationControllerDelegate
extension ViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

// MARK: - FramesTableViewControllerDelegate
extension ViewController: FramesTableViewControllerDelegate {
    
    func didSelectFrame(frame: Frame) {
        self.framesManager.selectFrame(frame: frame)
        dismiss(animated: true)
    }
}

// MARK: - FramesManagerDelegate
extension ViewController: FramesManagerDelegate {
    
    func didUpdateSelectedFrame(frame: Frame) {
        updateCanvas(withSelectedFrame: frame)
    }
}

// MARK: - AnimationDemoManagerDelegate
extension ViewController: AnimationDemoManagerDelegate {
    
    func didStartAnimationPlaying(fromFrame frame: Frame) {
        pauseButton.isEnabled = true
        playButton.isEnabled = false
        canvasView.isUserInteractionEnabled = false
        
        updateIsControlsHidden(true)
    }
    
    func didAnimationChangedFrame(_ frame: Frame) {
        canvasView.configure(currentFrame: frame, previousFrame: nil)
    }
    
    func didEndAnimationPlaying() {
        pauseButton.isEnabled = false
        playButton.isEnabled = true
        canvasView.isUserInteractionEnabled = true
        
        if let lastFrame = framesManager.frames.last {
            framesManager.selectFrame(frame: lastFrame)
        }
        
        updateIsControlsHidden(false)
    }
    
    private func updateIsControlsHidden(_ isHidden: Bool) {
        historyManagementPanel.isHidden = isHidden
        frameManagementPanel.isHidden = isHidden
        toolsPanelView.isHidden = isHidden
        previousFrameImageView.isHidden = isHidden
        
        shareButton.isHidden = !isHidden
        demoAnimationSpeedContainer.isHidden = !isHidden
    }
}

// MARK: - AnimationSpeedSliderViewDelegate
extension ViewController: AnimationSpeedSliderViewDelegate {
    
    func didUpdateSpeed(_ speed: Float) {
        animationDemoManager.updateDemoSpeed(speed: TimeInterval(speed))
    }
}
