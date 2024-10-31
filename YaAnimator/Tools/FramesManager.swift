//
//  FramesManager.swift
//  YaAnimator
//
//  Created by Vlad Eliseev on 30.10.2024.
//

import Foundation

final class FramesManager {
    
    var frames: [Frame] = [
        .init()
    ] {
        didSet {
            print(frames)
        }
    }
}

extension FileManager {
    
    func getDocumentsDirectory() -> URL {
        let paths = self.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
