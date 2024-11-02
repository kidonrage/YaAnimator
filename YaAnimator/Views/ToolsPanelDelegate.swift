//
//  ToolPanelDelegate.swift
//  YaAnimator
//
//  Created by Vlad Eliseev on 02.11.2024.
//

import Foundation

protocol ToolsPanelDelegate: AnyObject {
    
    func didSelectTool(_ tool: Tool)
    func didSelectColor(_ color: ColorPreset)
}
