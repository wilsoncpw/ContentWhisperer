//
//  PDFContentPlayer.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 21/11/2019.
//  Copyright © 2019 Colin Wilson. All rights reserved.
//

import Cocoa

class PDFContentPlayer: ContentPlayer {
    var suggestedSize: NSSize?
    
    let doc: CGPDFDocument
    var delegate: ContentPlayerDelegate?
    
    // Can't use lazy var here because the CALayer changes on next/prev page
    var caLayer: CALayer? { getCachedCALayer() }
    var _caLayer: CALayer?
        
    var duration = Double (0)
    
    var currentPosition = Double (0)
    
    let isPlaying = false
    
    var currentPage = 1
    
    init (doc: CGPDFDocument) {
        self.doc = doc
    }
    
    private func getCachedCALayer () -> CALayer? {
        if _caLayer == nil {
            _caLayer = getCALayer()
        }
        return _caLayer
    }
    
    private func getCGImage (page: Int) -> CGImage? {
        return doc.getNSImage(page: page)?.cgImage(forProposedRect: nil, context: nil, hints: nil)
    }
    
    private func getCALayer () -> CALayer? {
        guard let cg = getCGImage(page: currentPage) else { return nil }
                
        let rv = CALayer ()
        
        rv.isOpaque =  true
        rv.contentsGravity = .resizeAspect
        rv.shadowOpacity = 1
        rv.shadowRadius = 20
        rv.contents = cg
 //       rv.backgroundColor = NSColor.white.cgColor
        
        return rv
    }
    
    func play() {}
    func stop() {}
    
    func nextPage () {
        
        if currentPage < doc.numberOfPages {
            _caLayer = nil
            currentPage += 1
        }
    }
    
    func prevPage () {
        if currentPage > 1 {
            _caLayer = nil
            currentPage -= 1
        }
    }
    
    func takeSnaphot () -> CGImage? {
        return getCGImage(page: currentPage)
    }
}


