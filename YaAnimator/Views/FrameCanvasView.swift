//
//  FrameCanvasView.swift
//  YaAnimator
//
//  Created by Vlad Eliseev on 29.10.2024.
//

import UIKit

final class FrameCanvasView: UIView {
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "canvasBackground")
        return iv
    }()
    private let panRecognizer = UIPanGestureRecognizer()
    
    private var actionsHistory: [Action] = []
    private var actionsCanceled: [Action] = []
    
    private var actionInProgress: Action?
    
    private var lastPoint: CGPoint?
    
    var selectedTool: Tool = .pen // todo: remove
    
    private let painter = Painter()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = bounds
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
        guard let actionInProgress else { return }
        
        touchesMoved(touches, with: event)
        
        actionsHistory.append(actionInProgress)
        
        self.imageView.image = painter.draw(actions: actionsHistory, canvasSize: imageView.frame.size)
        self.actionInProgress = nil
        
        setNeedsDisplay()
    }
    
    private func setup() {
        addSubview(imageView)
    }
}

// MARK: - ToolsPanelDelegate
extension FrameCanvasView: ToolsPanelDelegate {
    
    func undo() {
        guard !actionsHistory.isEmpty else { return }
        let actionToCancel = actionsHistory.removeLast()
        
        // todo: ref
        self.imageView.image = painter.draw(actions: actionsHistory, canvasSize: imageView.frame.size)
        
        actionsCanceled.append(actionToCancel)
    }
    
    func redo() {
        guard !actionsCanceled.isEmpty else { return }
        let canceledAction = actionsCanceled.removeLast()
        
        // todo: ref
        actionsHistory.append(canceledAction)
        self.imageView.image = painter.draw(actions: actionsHistory, canvasSize: imageView.frame.size)
    }
    
    func didSelectTool(_ tool: Tool) {
        self.selectedTool = tool
    }
}
