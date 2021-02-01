//
//  ImageContrentControllerswift
//  ContentWhisperer
//
//  Created by Colin Wilson on 12/11/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa

//========================================================================================
/// ImageContentController
class ImageContentController: ContentController, ContentPagination {
        
    private let source: CGImageSource
    
    init (source: CGImageSource) {
        self.source = source
    }
    
    typealias CGImageProperties = NSDictionary
    
    private var _primaryProperties: CGImageProperties?
    private var _duration = Float (0)
    private var _firstValidImageIndex: Int?
    private var _isHeic = false
    
    private lazy var imageCount = getImageCount ()
    private lazy var images = getImages ()
    
    private var _caLayer: CALayer?
    private var currentImage = 0
    
    var caLayer: CALayer? { getCachedCALayer() }
    lazy var isHeic = imageCount > 1 && _isHeic
    lazy var animated = imageCount > 1 && !isHeic
    lazy var primaryImageMetadata = getPrimaryImageMetaData ()
    lazy var primaryProperties = imageCount > 0 ? _primaryProperties : nil
    
    private func getImageCount () -> Int {
        return images.count
    }
    
    private func getGifFrameDuration (props : CGImageProperties?) -> Float {
        var frameDuration = Float (0.1)
        if
            let props = props,
            let dict = props.value(forKey: kCGImagePropertyGIFDictionary as String) as? NSDictionary,
            let val = dict.value(forKey: kCGImagePropertyGIFDelayTime as String) as? NSNumber {
            frameDuration = val.floatValue
        }
        return frameDuration
    }
    
    private func _getIsHeic () -> Bool {
        guard let tp = CGImageSourceGetType(source) else {
            return false
        }
        let type = String (tp)
        return type == "public.heic"
    }
    
    private func getImages () -> [CGImage] {
        var cgImages = [CGImage] ()
        _duration = 0
        
        var firstValidImage = true
        let _imageCount = CGImageSourceGetCount(source)
        _isHeic = _imageCount > 1 && _getIsHeic()
        let _animated = !_isHeic && _imageCount > 1
        
        for i in 0..<_imageCount {
            if let img = CGImageSourceCreateImageAtIndex(source, i, nil) {
                if firstValidImage {_firstValidImageIndex = i }
                if _animated {
                    let props = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as CGImageProperties?
                    if firstValidImage {_primaryProperties = props}
                    _duration += getGifFrameDuration(props: props)
                }
                firstValidImage = false
                cgImages.append(img)
            }
        }
        return cgImages
    }
    
    private func getPrimaryPropeties () -> CGImageProperties? {
        guard imageCount > 0 else { return nil }
        if let props = _primaryProperties { return props }
        guard let idx = _firstValidImageIndex else { return nil }
        return CGImageSourceCopyPropertiesAtIndex(source, idx, nil) as CGImageProperties?
    }
        
    private func getPrimaryImageMetaData () -> CGImageMetadata? {
        guard imageCount > 0, let idx = _firstValidImageIndex else { return nil }
        return CGImageSourceCopyMetadataAtIndex(source, idx, nil)
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
        
        if animated {
            let animation = CAKeyframeAnimation (keyPath: "contents")
            animation.values = images
            animation.calculationMode = CAAnimationCalculationMode.discrete
            animation.duration = CFTimeInterval (_duration)
            animation.repeatCount = Float.infinity
            rv.add(animation, forKey: "contents")
            
        } else {
            rv.contents = images [currentImage]
        }
        
        return rv
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

