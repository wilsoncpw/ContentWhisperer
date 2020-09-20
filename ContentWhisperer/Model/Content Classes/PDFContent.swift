//
//  PDFContent.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 21/11/2019.
//  Copyright © 2019 Colin Wilson. All rights reserved.
//

import Cocoa



final class PDFContent: ContentBase, Content {

    static let contentType = ContentType (
        name: "Documents",
        fileTypes: Set<String> (["pdf"]),
        bucketDefinitions: [
            (name: "PDF Documents", fileTypes: Set<String> (["pdf"]))
        ],
        contentClass: PDFContent.self)
    
    private func getDocument (folderURL: URL) -> CGPDFDocument? {
        let url = getURL (folderURL: folderURL)
        return CGPDFDocument (url as CFURL)
    }
    
    func getThumbnailCGImage (folderURL: URL) -> CGImage? {
        guard let doc = getDocument(folderURL: folderURL) else { return nil }

        let rv = doc.getNSImage(page: 1)?.cgImage(forProposedRect: nil, context: nil, hints: nil)
        return rv
    }
    
    func getPlayer (folderURL: URL) -> ContentPlayer? {
        guard let doc = getDocument(folderURL: folderURL) else { return nil }
        return PDFContentPlayer (doc: doc)
    }
}
