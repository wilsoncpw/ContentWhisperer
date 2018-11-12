//
//  ImageContent.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa

final class ImageContent: ContentBase, Content {
    let duration = Double (0)
    
    var currentPosition = Double (0)
    
    static let contentType = ContentType (
        name: "Images",
        fileTypes: Set<String> (["jpg", "jpeg", "png", "tiff", "gif", "heic"]),
        bucketDefinitions: [
            (name: "Photos", fileTypes: Set<String> (["jpg", "jpeg", "png", "heic"])),
            (name: "Animated", fileTypes: Set<String> (["gif"]))],
        contentClass: ImageContent.self)
    
    private func getImageSource (folderURL: URL) -> CGImageSource? {
        return CGImageSourceCreateWithURL(folderURL.appendingPathComponent(fileName) as CFURL, nil)
    }
    
    func getThumbnailCGImage (folderURL: URL) -> CGImage? {
        if let source = getImageSource(folderURL: folderURL) {
            let options: [NSString: AnyObject] = [
                kCGImageSourceCreateThumbnailFromImageAlways: kCFBooleanTrue,
                kCGImageSourceThumbnailMaxPixelSize: 200 as CFNumber,
                kCGImageSourceShouldCache: kCFBooleanFalse
            ]
            return CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary)
         }
        return nil
    }
    
    func getPlayer (folderURL: URL) -> ContentPlayer? {
        if let source = getImageSource(folderURL: folderURL) {
            return ImageContentPlayer (source: source)
        }
        return nil
    }
}

class ImageContentPlayer: ContentPlayer {
    
    var delegate: ContentPlayerDelegate?
    let duration = Double (0)
    var currentPosition = Double (0)
    
    let source: CGImageSource
    
    init (source: CGImageSource) {
        self.source = source
    }
    
    lazy var caLayer = getCALayer ()
    
    private func getCALayer () -> CALayer? {
        
        typealias CGImageProperties = NSDictionary
        
        let imageCount = CGImageSourceGetCount(source)
        if imageCount == 0 {
            return nil
        }
        
        var cgImages = [CGImage] ()
        var cgProperties = [CGImageProperties?] ()
        
        for i in 0..<imageCount {
            if let img = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let prop = CGImageSourceCopyPropertiesAtIndex(source, i, nil)
                
                cgImages.append(img)
                cgProperties.append(prop)
            }
        }
        
        let rv = CALayer ()
        
        rv.isOpaque = true
        rv.contentsGravity = .resizeAspect
        rv.shadowOpacity = 1
        rv.shadowRadius = 20
        
        if imageCount > 1 {
            var duration = Float (0)
            for i in 0..<imageCount {
                var frameDuration = Float (0.1)
                if  let props = cgProperties [i],
                    let dict = props.value(forKey: kCGImagePropertyGIFDictionary as String) as? NSDictionary,
                    let val = dict.value(forKey: kCGImagePropertyGIFDelayTime as String) as? NSNumber {
                    frameDuration = val.floatValue
                }
                duration += frameDuration
            }
            
            let animation = CAKeyframeAnimation (keyPath: "contents")
            animation.values = cgImages
            animation.calculationMode = CAAnimationCalculationMode.discrete
            animation.duration = CFTimeInterval (duration)
            animation.repeatCount = Float.infinity
            rv.add(animation, forKey: "contents")
            
        } else {
            rv.contents = cgImages [0]
        }
        
        return rv
    }
    
    func play() {}
    
    func stop () {}
}
