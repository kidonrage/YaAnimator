//
//  Painter.swift
//  YaAnimator
//
//  Created by Vlad Eliseev on 29.10.2024.
//

import UIKit

struct Painter {
    
    private let brushSize: CGFloat = 15
    
    func draw(actions: [Action], canvasSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, 1)
        
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        let lineWidth: CGFloat = brushSize
        
        for action in actions {
            
            // todo: refactor
            let color: UIColor
            switch action.tool {
            case .pen:
                color = UIColor.init(red: 207/255, green: 66/255, blue: 68/255, alpha: 1)
            case .eraser:
                color = UIColor.clear
            }
            
            // todo: refactor
            let blendMode: CGBlendMode
            switch action.tool {
            case .pen:
                blendMode = .normal
            case .eraser:
                blendMode = .clear
            }
            
            ctx.addPath(action.path.cgPath)
            ctx.setLineCap(CGLineCap.round)
            ctx.setLineWidth(lineWidth)
            ctx.setStrokeColor(color.cgColor)
            ctx.setBlendMode(blendMode)
            ctx.strokePath()
        }
        
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return output
    }
}
