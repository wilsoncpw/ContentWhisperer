//
//  CALayerControllerFromContentBucket.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 02/11/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa

class CALayerControllerFromContentBucket {
    let contents: Contents
    let bucket: ContentBucket

    init (contents: Contents, bucket: ContentBucket) {
        self.contents = contents
        self.bucket = bucket
    }
    
    var contentCount: Int {
        return bucket.contents.count
    }
    
    func getCALayer (idx: Int) -> CALayer? {
        let content = bucket.contents [idx]
        
        return content.getDisplayLayer(folderURL: contents.folderURL)
    }
    
    func getDuration (idx: Int) -> Double {
        let content = bucket.contents [idx]
        return content.duration
    }
    
    func getCurrentPosition (idx: Int) -> Double {
        let content = bucket.contents [idx]
        return content.currentPosition
    }
    
    func setCurrentPosition (idx: Int, value: Double) {
        var content = bucket.contents [idx]
        content.currentPosition = value
    }
    
    func finished (idx: Int) {
        let content = bucket.contents [idx]
        content.finished()
    }
}
