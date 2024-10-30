//
//  Painter.swift
//  YaAnimator
//
//  Created by Vlad Eliseev on 29.10.2024.
//

import UIKit

struct Painter {
    
    private let brushSize: CGFloat = 15
    
    func draw(action: Action) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        let lineWidth: CGFloat = brushSize
        
        // todo: refactor
        let color: UIColor = getColor(forTool: action.tool)
        
        // todo: refactor
        let blendMode: CGBlendMode = getBlendMode(forTool: action.tool)
        
        ctx.setShouldAntialias(false)
        
        ctx.addPath(action.path.cgPath)
        ctx.setLineCap(.round)
        ctx.setLineWidth(lineWidth)
        ctx.setStrokeColor(color.cgColor)
        ctx.setBlendMode(blendMode)
//        ctx.setAlpha(1.0)
        ctx.strokePath()
    }
    
    private func getColor(forTool tool: Tool) -> UIColor {
        switch tool {
        case .pen:
            return UIColor.init(red: 207/255, green: 66/255, blue: 68/255, alpha: 1)
        case .eraser:
            return UIColor.clear
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
