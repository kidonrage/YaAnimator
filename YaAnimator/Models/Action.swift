//
//  Action.swift
//  YaAnimator
//
//  Created by Vlad Eliseev on 29.10.2024.
//

import UIKit

struct Action {
    
    let tool: Tool
    private(set) var path: UIBezierPath
    
    init(tool: Tool, startingPoint: CGPoint) {
        self.tool = tool
        
        let path = UIBezierPath()
        path.move(to: startingPoint)
        self.path = path
    }
    
    func addPoint(_ pointToAdd: CGPoint) {
        // TODO: Smoothing
        
        path.addLine(to: pointToAdd)
    }
    
    func createBezierRenderingBox() -> CGRect {
        // TODO: Tune
        
        var boundingBox = path.cgPath.boundingBox
        boundingBox.origin.x -= (15 / 2)
        boundingBox.origin.y -= (15 / 2)
        boundingBox.size.width += 15
        boundingBox.size.height += 15
        return boundingBox
    }
}
