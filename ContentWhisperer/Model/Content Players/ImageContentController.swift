//
//  ImageContrentControllerswift
//  ContentWhisperer
//
//  Created by Colin Wilson on 12/11/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa

class ImageContentController: ContentController, ContentPagination {
    
    var suggestedSize: NSSize?
    
    private let source: CGImageSource
    
    init (source: CGImageSource) {
        self.source = source
    }
    
    typealias CGImageProperties = NSDictionary
    
    private lazy var _imageCount = CGImageSourceGetCount(source)
    private var _properties: [CGImageProperties?]?
    private var _metaData : [CGImageMetadata?]?
    
    private lazy var imageCount = getImageCount ()
    private lazy var images = getImages ()
    private lazy var properties = getProperties ()
    private lazy var metaData = getMetaData ()
    
    private var _caLayer: CALayer?
    private var currentImage = 0
    var caLayer: CALayer? { getCachedCALayer() }
    lazy var isHeic = getIsHeic()
    lazy var primaryImageMetadata = getPrimaryImageMetaData ()
    
    private func getImageCount () -> Int {
        return images.count
    }
    
    private func getImages () -> [CGImage] {
        var cgImages = [CGImage] ()
        _properties = [CGImageProperties?] ()
        _metaData = [CGImageMetadata?] ()
        for i in 0..<_imageCount {
            if let img = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let prop = CGImageSourceCopyPropertiesAtIndex(source, i, nil)
                let meta = CGImageSourceCopyMetadataAtIndex(source, i, nil)

                cgImages.append(img)
                _properties?.append(prop)
                _metaData?.append(meta)
            }
        }
        return cgImages
    }
    
    private func getProperties () -> [CGImageProperties?] {
        return images.count > 0 ? _properties! : [CGImageProperties?]()
    }
    
    private func getMetaData () -> [CGImageMetadata?] {
        return images.count > 0 ? _metaData! : [CGImageMetadata?] ()
    }
    
    private func getPrimaryImageMetaData () -> CGImageMetadata? {
        return metaData.count > 0 ? metaData [0] : nil
    }
    
    private func getCachedCALayer () -> CALayer? {
        if _caLayer == nil {
            _caLayer = getCALayer()
        }
        return _caLayer
    }
    
    private func getCALayer () -> CALayer? {
        
        let rv = CALayer ()
        
        rv.isOpaque = true
        rv.contentsGravity = .resizeAspect
        rv.shadowOpacity = 1
        rv.shadowRadius = 20
        
        if !isHeic && imageCount > 1 {
            var duration = Float (0)
            for i in 0..<imageCount {
                var frameDuration = Float (0.1)
                if  let props = properties [i],
                    let dict = props.value(forKey: kCGImagePropertyGIFDictionary as String) as? NSDictionary,
                    let val = dict.value(forKey: kCGImagePropertyGIFDelayTime as String) as? NSNumber {
                    frameDuration = val.floatValue
                }
                duration += frameDuration
            }
            
            let animation = CAKeyframeAnimation (keyPath: "contents")
            animation.values = images
            animation.calculationMode = CAAnimationCalculationMode.discrete
            animation.duration = CFTimeInterval (duration)
            animation.repeatCount = Float.infinity
            rv.add(animation, forKey: "contents")
            
        } else {
            rv.contents = images [currentImage]
        }
        
        return rv
    }
    
    private func getIsHeic () -> Bool {
        guard let tp = CGImageSourceGetType(source) else {
            return false
        }
        let type = String (tp)
        return type == "public.heic" && imageCount > 1
    }
    
    func nextPage() {
        guard isHeic else { return }
        
        if currentImage < imageCount - 1 {
            _caLayer = nil
            currentImage += 1
        }
    }
    
    func prevPage () {
        guard isHeic else { return }
        
        if currentImage > 0 {
            _caLayer = nil
            currentImage -= 1
        }
    }
    
    func takeSnaphot () -> CGImage? {
        let idx = isHeic ? currentImage : 0
        return images.count > 0 ? images [idx] : nil
    }
    

}

