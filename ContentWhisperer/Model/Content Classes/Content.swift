//
//  ContentBase.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa
import AVKit

///=================================================================================
/// ContentType.  Each content class provides a static one of these, which is used to register with the content provider
struct ContentType {
    let fileTypes:Set<String>
    let name: String
    let bucketDefinitions: [(name: String, fileTypes: Set<String>)]
    let contentClass: Content.Type
    
    init (name: String, fileTypes: Set<String>, bucketDefinitions: [(name: String, fileTypes: Set<String>)], contentClass: Content.Type) {
        self.name = name
        self.fileTypes = fileTypes
        self.bucketDefinitions = bucketDefinitions
        self.contentClass = contentClass
    }
}

///=================================================================================
/// Content protocol
protocol Content {
    static var contentType: ContentType { get }
    init (fileName: String)
    var fileName: String { get }
    func getThumbnailCGImage (folderURL: URL) -> CGImage?
    func getPlayer (folderURL: URL) -> ContentPlayer?
    var displayName: String { get }
}

