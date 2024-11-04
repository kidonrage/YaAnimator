//
//  Action.swift
//  YaAnimator
//
//  Created by Vlad Eliseev on 29.10.2024.
//

import UIKit

struct Action {
    
    let tool: Tool
    let selectedColor: UIColor
    let selectedBrushSize: CGFloat
    private(set) var path: CGMutablePath
    
    init(tool: Tool, selectedColor: UIColor, selectedBrushSize: CGFloat, startingPoint: CGPoint) {
        self.tool = tool
        
        let path = CGMutablePath()
        path.move(to: startingPoint)
        self.path = path
        self.selectedBrushSize = selectedBrushSize
        self.selectedColor = selectedColor
    }
    
    func continuePath(
        to point: CGPoint,
        prevPointA: CGPoint,
        prevPointB: CGPoint
    ) -> CGRect {
        let subpath = CGPath.makeSubpath(
            cgPoint: point,
            previousPoint1: prevPointA,
            previousPoint2: prevPointB
        )
        
        path.addPath(subpath)
        
        return subpath.getExpandedBoundingBox(lineWidth: selectedBrushSize)
    }
}


