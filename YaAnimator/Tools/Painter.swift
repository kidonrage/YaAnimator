//
//  Painter.swift
//  YaAnimator
//
//  Created by Vlad Eliseev on 29.10.2024.
//

import UIKit

class Painter {
    
    private let brushSize: CGFloat = 15
    
    var selectedColor: CGColor?
    
    func draw(action: Action, context ctx: CGContext) {
        let lineWidth: CGFloat = brushSize
        
        // todo: refactor
        let color: CGColor = getColor(forTool: action.tool)
        
        // todo: refactor
        let blendMode: CGBlendMode = getBlendMode(forTool: action.tool)
        
        ctx.setShouldAntialias(false)
        
        ctx.addPath(action.path.cgPath)
        ctx.setLineCap(.round)
        ctx.setLineWidth(lineWidth)
        ctx.setStrokeColor(color)
        ctx.setBlendMode(blendMode)
//        ctx.setAlpha(1.0)
        ctx.strokePath()
    }
    
    private func getColor(forTool tool: Tool) -> CGColor {
        switch tool {
        case .pen:
            return selectedColor ?? UIColor.clear.cgColor
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
