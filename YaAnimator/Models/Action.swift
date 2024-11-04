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
    
    init(tool: Tool, selectedColor: UIColor, selectedBrushSize: CGFloat, points: [CGPoint]) {
        self.tool = tool
        
        var tempPoints = points
        
        let initialPoint = tempPoints.removeFirst()
        
        var currentPoint: CGPoint = initialPoint
        var previousPoint1: CGPoint = initialPoint
        var previousPoint2: CGPoint!
        
        let path = CGMutablePath()
        path.move(to: initialPoint)
        self.path = path
        self.selectedBrushSize = selectedBrushSize
        self.selectedColor = selectedColor
        
        for point in tempPoints {
            previousPoint2 = previousPoint1
            previousPoint1 = currentPoint
            currentPoint = point
            let _ = continuePath(to: currentPoint, prevPointA: previousPoint1, prevPointB: previousPoint2)
        }
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


