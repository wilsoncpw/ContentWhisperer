//
//  CachedThumbnail.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 01/11/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

class CachedThumbnail {
    let folderURL: URL
    let content: Content
    private (set) var cgImage: CGImage?
    
    init (folderURL: URL, content: Content) {
        self.folderURL = folderURL
        self.content = content
    }
    
    deinit {
        //        print (fileName, " deinit")
    }
    
    //-----------------------------------------------------------------------------------
    // load - called by the ThumbnailDownloaderOperation
    func load () {
        if (cgImage != nil) {
            return
        }
        
        cgImage = content.getThumbnailCGImage (folderURL: folderURL)
    }
}
