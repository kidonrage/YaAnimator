//
//  CGPath+boundingBox.swift
//  YaAnimator
//
//  Created by Vlad Eliseev on 03.11.2024.
//

import CoreGraphics

extension CGPath {
    
    func getExpandedBoundingBox(lineWidth: CGFloat) -> CGRect {
        var boundingBox: CGRect = self.boundingBox
        boundingBox.origin.x -= lineWidth * 2.0
        boundingBox.origin.y -= lineWidth * 2.0
        boundingBox.size.width += lineWidth * 4.0
        boundingBox.size.height += lineWidth * 4.0

        return boundingBox
    }
}
