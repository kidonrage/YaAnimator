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
    private(set) var path: CGMutablePath
    
    init(tool: Tool, selectedColor: UIColor, startingPoint: CGPoint) {
        self.tool = tool
        
        let path = CGMutablePath()
        path.move(to: startingPoint)
        self.path = path
        self.selectedColor = selectedColor
    }
    
    func continuePath(
        to point: CGPoint,
        prevPointA: CGPoint,
        prevPointB: CGPoint
    ) -> CGRect {
        let lineWidth: CGFloat = 15
        
        let subpath = CGPath.makeSubpath(
            cgPoint: point,
            previousPoint1: prevPointA,
            previousPoint2: prevPointB
        )
        
        path.addPath(subpath)
        
        return subpath.getExpandedBoundingBox(lineWidth: lineWidth)
    }
}


