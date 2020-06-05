//
//  CGPDFDocumentExtensions.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 05/06/2020.
//  Copyright © 2020 Colin Wilson. All rights reserved.
//

import Cocoa

extension CGPDFDocument {
    
    func getNSImage (page: Int) -> NSImage? {
        guard let page = self.page(at: page) else { return nil }
        let mediaBox = page.getBoxRect(.mediaBox)
        
        let rv = NSImage (size: mediaBox.size)
        rv.lockFocus()
        defer { rv.unlockFocus() }
        guard let context = NSGraphicsContext.current?.cgContext else { return nil }
        
        context.setFillColor(NSColor.white.cgColor)
        context.fill(CGRect (origin: .zero, size: mediaBox.size))
        
        if true {
            let pageTransform = page.getDrawingTransform(.mediaBox, rect: mediaBox, rotate: 0, preserveAspectRatio: true)
            context.concatenate(pageTransform)
        }
        
        context.drawPDFPage(page)
        return rv
    }
}
