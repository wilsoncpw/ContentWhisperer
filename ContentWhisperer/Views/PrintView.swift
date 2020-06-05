//
//  PrintView.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 04/06/2020.
//  Copyright © 2020 Colin Wilson. All rights reserved.
//

import Cocoa

typealias CGImageArray = [CGImage]
func compareCGFloat (x: CGFloat, y: CGFloat)->Int {
    let diff = abs (x-y)
    if diff < 0.0001 {
        return 0
    }
    
    return x < y ? -1 : 1
}

///=======================================================================================
/// PrintView class.  View used for printing images
class PrintView: NSView {
    
    var images: CGImageArray! = nil
    
    var image: CGImage!
    
    ///------------------------------------------------------------------------------------
    /// func draw
    ///
    /// - Parameter dirtyRect: The rect to draw in
    ///
    /// Note that, because we override knowsPageRange & rectForPage, the dirtyRect is controlled, so that it exactly fits
    /// the parti
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        
        guard let context = NSGraphicsContext.current?.cgContext else { return }
                
        let imageWidth = CGFloat (image.width)
        let imageHeight = CGFloat (image.height)
        
        let xscale = dirtyRect.width / imageWidth
        let yscale = dirtyRect.height / imageHeight
        
        var imageRect: NSRect
        let origin = dirtyRect.origin
        
        // Calculate imageRect - the largest rectangle, with the correct proportions for the image, that fits in the dirtyRect
        if compareCGFloat(x: xscale, y: yscale) > 0 {
            imageRect = NSRect (origin: origin, size: CGSize (width: imageWidth * yscale, height: imageHeight * yscale))
        }
        else {
            imageRect = NSRect (origin: origin, size: CGSize (width: imageWidth * xscale, height: imageHeight * xscale))
        }
        
        // Centre the imageRect in the dirtyRect
        if compareCGFloat(x: imageRect.size.width, y: dirtyRect.size.width) < 0 {
            imageRect.origin = NSPoint (x:(dirtyRect.size.width - imageRect.size.width) / 2, y: imageRect.origin.y)
        } else {
            imageRect.origin = NSPoint (x: imageRect.origin.x, y: (dirtyRect.size.height - imageRect.size.height) / 2)
        }
        context.draw(image, in: imageRect)
    }
    
    func setImages (images: CGImageArray) {
        self.images = images
    }
    
    override func knowsPageRange(_ range: NSRangePointer) -> Bool {
        range.pointee.location = 1
        range.pointee.length = images.count
        return true
    }
    
    override func rectForPage(_ page: Int) -> NSRect {
        image = images [page-1]
        
        if let currentOp = NSPrintOperation.current {
            frame = NSRect (origin: CGPoint (x: 0, y: 0), size: currentOp.printInfo.paperSize)
        }
        return bounds // NSRect (origin: .zero, size: CGSize (width: image.width, height: image.height))
    }
    
    
    func print () {
        if images == nil {
            return
        }
        
        frame = NSRect (origin: .zero, size: CGSize (width: images [0].width, height: images [0].height))
        
        let printInfo = NSPrintInfo ()
        printInfo.horizontalPagination = .automatic
        printInfo.verticalPagination = .automatic
        printInfo.orientation = .landscape
        
        let printOp = NSPrintOperation (view: self, printInfo: printInfo)
        
        printOp.printPanel.options.insert(NSPrintPanel.Options.showsOrientation)
        //       printOp.canSpawnSeparateThread = true;
        printOp.run()
    }
    
    
    
    
    
}

