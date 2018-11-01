//
//  ThumbnailView.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 01/11/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa

//=======================================================================================
class QuietLayoutManager : CAConstraintLayoutManager {
    
    static let instance = QuietLayoutManager ()
    
    override func layoutSublayers(of layer: CALayer) {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        super.layoutSublayers(of: layer)
        CATransaction.commit()
    }
}

let noTransform = CATransform3D (m11: 1, m12: 0, m13: 0, m14: 0, m21: 0, m22: 1, m23: 0, m24: 0, m31: 0, m32: 0, m33: 1, m34: 0, m41: 0, m42: 0, m43: 0, m44: 1)


class ThumbnailView: NSView {
    
    private var cgImage: CGImage?


    ///------------------------------------------------------------------------------------
    /// awakeFromNib
    override func awakeFromNib () {
        super.awakeFromNib()
        
        // Create the background layer
        let layer = CALayer ()
        layer.layoutManager = QuietLayoutManager.instance
        
        self.layer = layer
    }
    
    ///------------------------------------------------------------------------------------
    /// func setCGImage
    ///
    /// - Parameters:
    ///   - cgImage: The image to set
    ///   - imageAdjustments: The adjustments to apply
    func setCGImage (cgImage: CGImage?) {
        self.cgImage = cgImage
        updateLayer ();
    }
    
    ///------------------------------------------------------------------------------------
    /// wantsUpdateLayer
    override var wantsUpdateLayer: Bool {
        return true
    }
    
    ///------------------------------------------------------------------------------------
    /// updateLayer - draw the thumbnail
    override func updateLayer() {
        guard let layer = layer else { return }
        
        var cg = cgImage
        
        if cg == nil {
//            let blank = #imageLiteral(resourceName: "Placeholder")
//            var r = CGRect (x: 0, y: 0, width: 300, height: 300)
//            cg = blank.cgImage(forProposedRect: &r, context: nil, hints: nil)
        }
        
        let sublayer: CALayer
        
        // Display the image as a sublayer to the ThumbnailView's (background) layer
        
        if layer.sublayers == nil || layer.sublayers!.count == 0 {
            sublayer = CALayer ()
            
            sublayer.contentsGravity = CALayerContentsGravity.resizeAspect
            sublayer.isOpaque = true
            
            sublayer.addConstraint(CAConstraint (attribute: .minX, relativeTo: "superlayer", attribute: .minX, offset:10))
            sublayer.addConstraint(CAConstraint (attribute: .minY, relativeTo: "superlayer", attribute: .minY, offset:10))
            sublayer.addConstraint(CAConstraint (attribute: .maxX, relativeTo: "superlayer", attribute: .maxX, offset:-10))
            sublayer.addConstraint(CAConstraint (attribute: .maxY, relativeTo: "superlayer", attribute: .maxY, offset:-10))
            
            sublayer.shadowOpacity = 1.0
            sublayer.shadowRadius = 10
            
            layer.addSublayer(sublayer)
        } else {
            sublayer = layer.sublayers! [0]
        }
        

        sublayer.transform = noTransform
        sublayer.filters = nil
        
        sublayer.contents = cg
    }
    
}
