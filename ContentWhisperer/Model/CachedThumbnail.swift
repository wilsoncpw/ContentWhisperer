//
//  CachedThumbnail.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 01/11/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

// nb. We don't maintain the cache ourselves.  Instead, we rely on the thumbnails content view to create/free & cache CachedThumbnails when it needs to.
//
//

class CachedThumbnail {
    let folderURL: URL
    let content: Content
    private (set) var cgImage: CGImage?
    
    init (folderURL: URL, content: Content) {
        self.folderURL = folderURL
        self.content = content
    }
    
    deinit {
        //      print (folderURL, " deinit")
    }
    
    //-----------------------------------------------------------------------------------
    // load - called in the background by the ThumbnailDownloaderOperation
    func load () {
        if (cgImage != nil) {
            return
        }
        
        cgImage = content.getThumbnailCGImage (folderURL: folderURL)
    }
}
