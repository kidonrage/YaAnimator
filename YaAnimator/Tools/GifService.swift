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
            let fileProperties: CFDictionary = [
                kCGImagePropertyGIFDictionary: [kCGImagePropertyGIFLoopCount: 0]
            ] as CFDictionary
            let frameProperties: CFDictionary = [
                kCGImagePropertyGIFDictionary: [kCGImagePropertyGIFDelayTime: 1 / fps]
            ] as CFDictionary
            
            let fileURL: URL? = FileManager.default.getDocumentsDirectory().appendingPathComponent("animation.gif")
            
            guard
                let url = fileURL as CFURL?,
                let destination = CGImageDestinationCreateWithURL(
                    url, UTType.gif.identifier as CFString, frames.count, nil
                )
            else {
                completion(nil)
                return
            }
            
            CGImageDestinationSetProperties(destination, fileProperties)
            
            for frame in frames {
                autoreleasepool {
                    do {
                        let imageData = try Data(contentsOf: frame.frameSource)
                        let image = UIImage(data: imageData)
                        if let cgImage = image?.cgImage {
                            CGImageDestinationAddImage(destination, cgImage, frameProperties)
                        }
                    } catch {
                        debugPrint(error.localizedDescription)
                        return
                    }
                }
            }
            
            guard CGImageDestinationFinalize(destination) else {
                debugPrint("Finalization of gif failed")
                completion(nil)
                return
            }
            
            completion(fileURL)
        }
    }
}
