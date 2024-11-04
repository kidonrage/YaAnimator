//
//  GifExporter.swift
//  YaAnimator
//
//  Created by Vlad Eliseev on 04.11.2024.
//

import UIKit
import UniformTypeIdentifiers

final class GifService {
    
    func saveGif(fromFrames frames: [Frame], fps: Double, completion: @escaping (URL?) -> Void) {
        DispatchQueue.global().async {
            let imagesData = frames.compactMap {
                sleep(1)
                return try? Data(contentsOf: $0.frameSource)
            }
            DispatchQueue.main.async {
                let images = imagesData.compactMap { UIImage(data: $0) }
                let gifURL = self.saveAnimatedGif(
                    from: images, fps: fps
                )
                completion(gifURL)
            }
        }
    }
    
    private func saveAnimatedGif(from images: [UIImage], fps: Double) -> URL? {
        let fileProperties: CFDictionary = [
            kCGImagePropertyGIFDictionary: [kCGImagePropertyGIFLoopCount: 0]
        ] as CFDictionary
        let frameProperties: CFDictionary = [
            kCGImagePropertyGIFDictionary: [kCGImagePropertyGIFDelayTime: 1 / fps]
        ] as CFDictionary
        
        let fileURL: URL? = FileManager.default.temporaryDirectory.appendingPathComponent("animation.gif")
        
        guard
            let url = fileURL as CFURL?,
            let destination = CGImageDestinationCreateWithURL(
                url, UTType.gif.identifier as CFString, images.count, nil
            )
        else { return nil }
        
        CGImageDestinationSetProperties(destination, fileProperties)
        
        for image in images {
            if let cgImage = image.cgImage {
                CGImageDestinationAddImage(destination, cgImage, frameProperties)
            }
        }
        
        guard CGImageDestinationFinalize(destination) else {
            debugPrint("Finalization of gif failed")
            return nil
        }
        
        return fileURL
    }
}
