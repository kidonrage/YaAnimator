//
//  CGPath+subpath.swift
//  YaAnimator
//
//  Created by Vlad Eliseev on 03.11.2024.
//

import CoreGraphics

extension CGPath {
    
    static func makeSubpath(cgPoint: CGPoint, previousPoint1: CGPoint, previousPoint2: CGPoint) -> CGPath {
        let mid1 = middlePoint(previousPoint1, previousPoint2: previousPoint2)
        let mid2 = middlePoint(cgPoint, previousPoint2: previousPoint1)
        let subpath = CGMutablePath.init()
        subpath.move(to: CGPoint(x: mid1.x, y: mid1.y))
        subpath.addQuadCurve(
            to: CGPoint(x: mid2.x, y: mid2.y),
            control: CGPoint(x: previousPoint1.x, y: previousPoint1.y)
        )
        return subpath
    }
    
    private static func middlePoint(_ previousPoint1: CGPoint, previousPoint2: CGPoint) -> CGPoint {
        return CGPoint(
            x: (previousPoint1.x + previousPoint2.x) * 0.5,
            y: (previousPoint1.y + previousPoint2.y) * 0.5
        )
    }
}
