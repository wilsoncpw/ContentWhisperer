//
//  PDFContent.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 21/11/2019.
//  Copyright © 2019 Colin Wilson. All rights reserved.
//

import Cocoa

extension CGPDFDocument {
    func getNSImage (suggestedSize: NSSize?, page: Int) -> NSImage? {
        guard let page = self.page(at: page) else { return nil }
        let mediaBox = page.getBoxRect(.mediaBox)
        
        let sz = suggestedSize ?? mediaBox.size
        
        let rv = NSImage (size: sz)
        rv.lockFocus()
        defer { rv.unlockFocus() }
        guard let context = NSGraphicsContext.current?.cgContext else { return nil }
        
        if let suggestedSize = suggestedSize {
            let pageTransform = page.getDrawingTransform(.mediaBox, rect: CGRect (origin: .zero, size: suggestedSize), rotate: 0, preserveAspectRatio: true)
            context.concatenate(pageTransform)
        }
         
        context.drawPDFPage(page)
        return rv
    }
}

final class PDFContent: ContentBase, Content {
    
    static let contentType = ContentType (
        name: "Documents",
        fileTypes: Set<String> (["pdf"]),
        bucketDefinitions: [
            (name: "PDF Documents", fileTypes: Set<String> (["pdf"]))
        ],
        contentClass: PDFContent.self)
    
    private func getDocument (folderURL: URL) -> CGPDFDocument? {
        let url = (isRelativePath) ? folderURL.appendingPathComponent(fileName) : URL (fileURLWithPath: fileName)
        return CGPDFDocument (url as CFURL)
    }
    
    func getThumbnailCGImage (folderURL: URL) -> CGImage? {
        guard let doc = getDocument(folderURL: folderURL) else { return nil }

        let rv = doc.getNSImage(suggestedSize: NSSize (width: 200, height: 200), page: 1)?.cgImage(forProposedRect: nil, context: nil, hints: nil)
        return rv
    }
    
    func getPlayer (folderURL: URL) -> ContentPlayer? {
        guard let doc = getDocument(folderURL: folderURL) else { return nil }
        return PDFContentPlayer (doc: doc)
    }
}
