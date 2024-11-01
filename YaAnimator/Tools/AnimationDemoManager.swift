//
//  AnimationDemoManager.swift
//  YaAnimator
//
//  Created by Vlad Eliseev on 01.11.2024.
//

import Foundation

protocol AnimationDemoManagerDelegate: AnyObject {
    
    func didStartAnimationPlaying(fromFrame frame: Frame)
    func didAnimationChangedFrame(_ frame: Frame)
    func didEndAnimationPlaying()
}

final class AnimationDemoManager {
    
    private var displayingFrame: Frame? {
        didSet {
            guard let displayingFrame else { return }
            delegate?.didAnimationChangedFrame(displayingFrame)
        }
    }
    private var animatedFrames: [Frame] = []
    
    private var animationDemoTimer: Timer?
    
    weak var delegate: AnimationDemoManagerDelegate?
    
    func startAnimation(frames: [Frame], selectedFrame: Frame) {
        displayingFrame = selectedFrame
        animatedFrames = frames
        
        animationDemoTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] timer in
            guard
                let self,
                let currentFrameIndex = self.animatedFrames.firstIndex(where: { $0.id == self.displayingFrame?.id })
            else { return }
            
            let nextFrameIndex = currentFrameIndex < self.animatedFrames.count - 1
                ? currentFrameIndex + 1
                : 0
            let nextFrame = self.animatedFrames[nextFrameIndex]
            
            self.displayingFrame = nextFrame
        })
        
        delegate?.didStartAnimationPlaying(fromFrame: selectedFrame)
    }
    
    func stopAnimation() {
        animationDemoTimer?.invalidate()
        
        delegate?.didEndAnimationPlaying()
    }
}
