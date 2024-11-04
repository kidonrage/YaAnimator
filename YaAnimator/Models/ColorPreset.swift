//
//  ColorPreset.swift
//  YaAnimator
//
//  Created by Vlad Eliseev on 02.11.2024.
//

import UIKit

enum ColorPreset: Int, CaseIterable {
    
    case white
    case red
    case black
    case blue
    
    var uiColor: UIColor {
        switch self {
        case .white:
            return .white
        case .red:
            return .init(r: 255, g: 61, b: 0)
        case .black:
            return .init(r: 28, g: 28, b: 28)
        case .blue:
            return .init(r: 25, g: 118, b: 210)
        }
    }
}
