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
        print("Adding \(pointToAdd) next to \(path.currentPoint)")
        path.addLine(to: pointToAdd)
    }
    
    func createBezierRenderingBox() -> CGRect {
        return path.cgPath.boundingBox
    }
}
