//
//  Frame.swift
//  YaAnimator
//
//  Created by Vlad Eliseev on 31.10.2024.
//

import Foundation

struct Frame {
    
    let id: UUID
    let frameSource: URL
    
    init() {
        let id = UUID()
        
        self.id = id
        self.frameSource = FileManager.default.getDocumentsDirectory().appendingPathComponent("\(id.uuidString).png")
    }
    
    init(id: UUID) {
        self.id = id
        self.frameSource = FileManager.default.sourceForFrame(withId: id)
    }
}
