//
//  FileManager+ext.swift
//  YaAnimator
//
//  Created by Vlad Eliseev on 04.11.2024.
//

import Foundation

extension FileManager {
    
    func getTemproraryFilesDirectory() -> URL {
        return URL(fileURLWithPath: NSTemporaryDirectory(),
                  isDirectory: true)
    }
    
    func sourceForFrame(withId frameId: UUID) -> URL {
        getTemproraryFilesDirectory().appendingPathComponent("\(frameId.uuidString).png")
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
