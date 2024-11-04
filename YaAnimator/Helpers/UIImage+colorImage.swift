//
//  UIImage+colorImage.swift
//  YaAnimator
//
//  Created by Vlad Eliseev on 02.11.2024.
//

import UIKit


extension UIImage {
    
    static func colorIcon(
        size: CGSize = CGSize(width: 28, height: 28),
        color: UIColor,
        isHighlighted: Bool
    ) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)

        let hightlightStrokeWidth: CGFloat = 2
        return renderer.image { ctx in
            ctx.cgContext.setFillColor(color.cgColor)
            ctx.cgContext.fillEllipse(in: .init(origin: .zero, size: size))
            if isHighlighted {
                ctx.cgContext.setLineWidth(hightlightStrokeWidth)
                ctx.cgContext.setStrokeColor(UIColor.buttonAccent.cgColor)
                ctx.cgContext.strokeEllipse(
                    in: .init(
                        origin: .init(x: hightlightStrokeWidth / 2, y: hightlightStrokeWidth / 2),
                        size: CGSize(
                            width: size.width - hightlightStrokeWidth,
                            height: size.height - hightlightStrokeWidth
                        )
                    )
                )
            }
        }
    }
}
