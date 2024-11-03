//
//  FrameCanvasView.swift
//  YaAnimator
//
//  Created by Vlad Eliseev on 29.10.2024.
//

import UIKit

final class FrameCanvasView: UIView {
    
    private let backgroundImage: UIImage? = nil // TODO: Return back or delete
    private var previousFrameImage: UIImage? // image of the previous frame
    private var initialFrameImage: UIImage? // image of the frame in the beginning of actions history
    private var image: UIImage? // cached current state of frame
    
    private var currentFrame: Frame
    
    private var selectedTool: Tool!
    private var selectedColor: ColorPreset!
    
    private var previousPoint1: CGPoint?
    private var previousPoint2: CGPoint?
    private var currentPoint: CGPoint?
    
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
        image = nil
        initialFrameImage = nil
        previousFrameImage = nil
        actionInProgress = nil
        actionsHistory = []
        actionsCanceled = []
        
        if let currentFrameImageData = try? Data(contentsOf: currentFrame.frameSource) {
            self.image = UIImage(data: currentFrameImageData)
            self.initialFrameImage = image
        }
        
        if let previousFrame, let prevFrameImageData = try? Data(contentsOf: previousFrame.frameSource) {
            self.previousFrameImage = UIImage(data: prevFrameImageData)
        }
        
        self.currentFrame = currentFrame
        
        setNeedsDisplay()
        
        delegate?.didUpdateDrawing()
    }
    
    func copyCanvasContentToNewFrame() {
        let copyFrameId = UUID()
        let copyFrameImgSource = FileManager.default.sourceForFrame(withId: copyFrameId)
        do {
            try image?.pngData()?.write(to: copyFrameImgSource)
            FramesManager.shared.addFrame(id: copyFrameId)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    // MARK: - Drawing
    
    private func updateImage() {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        initialFrameImage?.draw(in: bounds)
        
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
        guard let touch = touches.first else { return }
        previousPoint1 = touch.previousLocation(in: self)
        currentPoint = touch.location(in: self)
        actionInProgress = Action(
            tool: selectedTool,
            selectedColor: selectedColor.uiColor,
            startingPoint: currentPoint!
        )
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let actionInProgress else { return }
        
        previousPoint2 = previousPoint1
        previousPoint1 = touch.previousLocation(in: self)
        currentPoint = touch.location(in: self)
        
        let renderingBox = actionInProgress.continuePath(
            to: currentPoint!,
            prevPointA: previousPoint1!,
            prevPointB: previousPoint2!
        )

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
    
    func didSelectTool(_ tool: Tool) {
        self.selectedTool = tool
    }
    
    func didSelectColor(_ color: ColorPreset) {
        self.selectedColor = color
    }
}

// MARK: - ActionsPanelDelegate
extension FrameCanvasView: ActionsPanelDelegate {
    
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
}
