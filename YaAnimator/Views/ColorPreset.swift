//
//  ColorPreset.swift
//  YaAnimator
//
//  Created by Vlad Eliseev on 02.11.2024.
//

import UIKit

enum ColorPreset: Int, CaseIterable {
    
    case red
    case green
    case blue
    
    var uiColor: UIColor {
        switch self {
        case .red:
            return .red
        case .green:
            return .green
        case .blue:
            return .blue
        }
    }
}
