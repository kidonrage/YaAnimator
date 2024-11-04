//
//  Painter.swift
//  YaAnimator
//
//  Created by Vlad Eliseev on 29.10.2024.
//

import UIKit

class Painter {
    
    func draw(action: Action, context ctx: CGContext) {
        let lineWidth: CGFloat = action.selectedBrushSize
        
        // todo: refactor
        let color: CGColor = getColor(forAction: action)
        
        // todo: refactor
        let blendMode: CGBlendMode = getBlendMode(forTool: action.tool)
        
        ctx.setShouldAntialias(false)
        
        ctx.addPath(action.path)
        ctx.setLineCap(.round)
        ctx.setLineWidth(lineWidth)
        ctx.setStrokeColor(color)
        ctx.setBlendMode(blendMode)
//        ctx.setAlpha(1.0)
        ctx.strokePath()
    }
    
    private func getColor(forAction action: Action) -> CGColor {
        switch action.tool {
        case .pen:
            return action.selectedColor.cgColor
        case .eraser:
            return UIColor.clear.cgColor
        }
    }
    
    private func getBlendMode(forTool tool: Tool) -> CGBlendMode {
        switch tool {
        case .pen:
            return .normal
        case .eraser:
            return .clear
        }
    }
}
