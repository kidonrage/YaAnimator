//
//  ActionsPanelDelegate.swift
//  YaAnimator
//
//  Created by Vlad Eliseev on 02.11.2024.
//

import Foundation

protocol ActionsPanelDelegate: AnyObject {
    
    var isUndoButtonEnabled: Bool { get }
    var isRedoButtonEnabled: Bool { get }
    
    func undo()
    func redo()
}
