//
//  FrameCanvasView.swift
//  YaAnimator
//
//  Created by Vlad Eliseev on 29.10.2024.
//

import UIKit

final class FrameCanvasView: UIView {
    
    private let backgroundImage: UIImage? = nil
    private var previousFrameImage: UIImage?
    private var image: UIImage?
    
    private var currentFrame: Frame
    
    private var selectedTool: Tool = .pen
    private var lastPoint: CGPoint?
    
    private var actionInProgress: Action?
    private var actionsHistory: [Action] = []
    private var actionsCanceled: [Action] = []

    private let painter = Painter()
    
    weak var delegate: FrameCanvasViewDelegate?
    
    init(initialFrame: Frame) {
        self.currentFrame = initialFrame
        
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        print("[TEST] draw", rect)
        
        backgroundImage?.draw(in: rect)
        
        previousFrameImage?.draw(in: rect, blendMode: .normal, alpha: 0.5)
        
        image?.draw(in: rect)
        
        if let actionInProgress {
            painter.draw(action: actionInProgress, context: ctx)
        }
    }
    
    // MARK: - Configuring
    func configure(currentFrame: Frame, previousFrame: Frame?) {
        if let currentFrameImageData = try? Data(contentsOf: currentFrame.frameSource) { 
            self.image = UIImage(data: currentFrameImageData)
        } else {
            self.image = nil
        }
        
        if let previousFrame, let prevFrameImageData = try? Data(contentsOf: previousFrame.frameSource) {
            self.previousFrameImage = UIImage(data: prevFrameImageData)
        } else {
            self.previousFrameImage = nil
        }
        
        lastPoint = nil
        
        actionInProgress = nil
        actionsHistory = []
        actionsCanceled = []
        
        self.currentFrame = currentFrame
        
        setNeedsDisplay()
        
        delegate?.didUpdateDrawing()
    }
    
    // MARK: - Drawing
    
    private func updateImage() {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        for action in actionsHistory {
            painter.draw(action: action, context: ctx)
        }
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        delegate?.didUpdateDrawing()
        
        do {
            try image?.pngData()?.write(to: currentFrame.frameSource)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    // MARK: - Gestures
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("[TEST] began")
        guard let touch = touches.first else { return }
        let startingPoint = touch.location(in: self)
        actionInProgress = Action(tool: selectedTool, startingPoint: startingPoint)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let actionInProgress else { return }
        
        actionInProgress.addPoint(touch.location(in: self))
        
        let renderingBox = actionInProgress.createBezierRenderingBox()

        setNeedsDisplay(renderingBox)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("[TEST] ended")
        guard let actionInProgress else { return }
        
        touchesMoved(touches, with: event)
        
        actionsHistory.append(actionInProgress)
        actionsCanceled.removeAll()
        
        updateImage()
        
        self.actionInProgress = nil
        
        setNeedsDisplay()
    }
    
    private func setup() {
        self.backgroundColor = .clear
    }
}

// MARK: - ToolsPanelDelegate
extension FrameCanvasView: ToolsPanelDelegate {
    
    var isUndoButtonEnabled: Bool {
        return !actionsHistory.isEmpty
    }
    
    var isRedoButtonEnabled: Bool {
        return !actionsCanceled.isEmpty
    }
    
    func undo() {
        guard !actionsHistory.isEmpty else { return }
        let actionToCancel = actionsHistory.removeLast()
        actionsCanceled.append(actionToCancel)
        
        updateImage()
        
        setNeedsDisplay()
    }
    
    func redo() {
        guard !actionsCanceled.isEmpty else { return }
        let canceledAction = actionsCanceled.removeLast()
        actionsHistory.append(canceledAction)
        
        updateImage()
        
        setNeedsDisplay()
    }
    
    func didSelectTool(_ tool: Tool) {
        self.selectedTool = tool
    }
}
