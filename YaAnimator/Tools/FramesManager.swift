//
//  FramesManager.swift
//  YaAnimator
//
//  Created by Vlad Eliseev on 30.10.2024.
//

import Foundation

protocol FramesManagerDelegate: AnyObject {
    
    func didUpdateSelectedFrame(frame: Frame)
}

final class FramesManager {
    
    static let shared = FramesManager()
    
    var isCurrentFrameRemovingEnabled: Bool {
        return frames.count > 1
    }
    
    private(set) var frames: [Frame] {
        didSet {
            print(frames)
        }
    }
    
    private(set) var selectedFrameIndex: Int {
        didSet {
            delegate?.didUpdateSelectedFrame(frame: selectedFrame)
        }
    }
    
    var selectedFrame: Frame {
        return frames[selectedFrameIndex]
    }
    
    weak var delegate: FramesManagerDelegate?
    
    private init() {
        let initialFrame = Frame()
        self.frames = [initialFrame]
        self.selectedFrameIndex = .zero
    }
    
    func selectFrame(frame: Frame) {
        self.selectedFrameIndex = frames.firstIndex(where: { $0.id == frame.id }) ?? selectedFrameIndex
    }
    
    func addFrame() {
        frames.append(.init())
        selectedFrameIndex = frames.count - 1
    }
    
    func deleteCurrentFrame() {
        guard isCurrentFrameRemovingEnabled else { return }
        let updatedCurrentFrameIndex = selectedFrameIndex > 0 ? selectedFrameIndex - 1 : 0
        frames.remove(at: selectedFrameIndex)
        selectedFrameIndex = updatedCurrentFrameIndex
    }
}

extension FileManager {
    
    func getDocumentsDirectory() -> URL {
        let paths = self.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
