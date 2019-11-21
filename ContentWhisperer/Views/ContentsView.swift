//
//  ContentsView.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 02/11/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa

class ContentsView: NSView {
    
    ///------------------------------------------------------------------------------------
    /// awakeFromNib
    override func awakeFromNib() {
        
        layerUsesCoreImageFilters = true // ... otherwise the filters in the sublayer don't get applied
        
        // Create tha background layer
        let layer = CALayer ()
        layer.layoutManager = QuietLayoutManager.instance
        layer.backgroundColor = CGColor (red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
        
        self.layer = layer
    }
    
    func setContentLayer (contentLayer: CALayer?) {
        layer?.sublayers?.forEach() { layer in
            layer.removeFromSuperlayer()
        }
        
        guard let contentLayer = contentLayer else {
            return
        }
        
        contentLayer.addConstraint(CAConstraint (attribute: .minX, relativeTo: "superlayer", attribute: .minX, offset:10))
        contentLayer.addConstraint(CAConstraint (attribute: .minY, relativeTo: "superlayer", attribute: .minY, offset:10))
        contentLayer.addConstraint(CAConstraint (attribute: .maxX, relativeTo: "superlayer", attribute: .maxX, offset:-10))
        contentLayer.addConstraint(CAConstraint (attribute: .maxY, relativeTo: "superlayer", attribute: .maxY, offset:-10))
        
        layer?.addSublayer(contentLayer)
    
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
}
