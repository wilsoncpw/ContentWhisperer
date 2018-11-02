//
//  ContentBase.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa

protocol Content {
    static var contentType: ContentType { get }
    init (fileName: String)
    var fileName: String { get }
    func getThumbnailCGImage (folderURL: URL) -> CGImage?
    func getDisplayLayer (folderURL: URL)->CALayer?
}

class ContentBase {
    let fileName: String

    required init (fileName: String) {
        self.fileName = fileName
    }
}
