//
//  PDFContentPlayer.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 21/11/2019.
//  Copyright © 2019 Colin Wilson. All rights reserved.
//

import Cocoa

class PDFContentPlayer: ContentPlayer {
    let doc: CGPDFDocument
    var delegate: ContentPlayerDelegate?
    
    lazy var caLayer = getCALayer ()
    
    var duration = Double (0)
    
    var currentPosition = Double (0)
    
    let isPlaying = false
    
    init (doc: CGPDFDocument) {
        self.doc = doc
    }
    
    func play() {
        
    }
    
    func stop() {
        
    }
    
    private func getCALayer () -> CALayer? {
        guard let image = doc.getNSImage(suggestedSize: nil, page: 1) else { return nil }
        
        let cg = image.cgImage(forProposedRect: nil, context: nil, hints: nil)
        
        let rv = CALayer ()
        
        rv.isOpaque = true
        rv.contentsGravity = .resizeAspect
        rv.shadowOpacity = 1
        rv.shadowRadius = 20
        rv.contents = cg
        
        return rv
    }
    
    
}


