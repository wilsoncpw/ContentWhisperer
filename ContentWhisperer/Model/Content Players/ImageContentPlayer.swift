//
//  ImageContrentPlayer.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 12/11/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa

class ImageContentPlayer: ContentPlayer {
    
    weak var delegate: ContentPlayerDelegate?
    let duration = Double (0)
    var currentPosition = Double (0)
    var suggestedSize: NSSize?
    let isPlaying = false
    
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
    
    func nextPage() {}
    
    func prevPage () {}
    
    func takeSnaphot () -> CGImage? {
        return CGImageSourceCreateImageAtIndex(source, 0, nil)
    }

}

