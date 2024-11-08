//
//  ToolPanelDelegate.swift
//  YaAnimator
//
//  Created by Vlad Eliseev on 02.11.2024.
//

import UIKit

protocol ToolsPanelDelegate: AnyObject {
    
    func didSelectTool(_ tool: Tool)
    func didSelectColor(_ color: UIColor)
    func didSelectBrushSize(_ brushSize: CGFloat)
}

protocol ToolsPanelViewDelegate: AnyObject {
    
    func didTapOnColorButton()
}
