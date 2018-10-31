//
//  ThumbnailsCollectionFromContentBucket.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 31/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

protocol ThumbnailsController {
    var contents: Contents { get }
    var contentCount: Int { get }
    func getThumbnail (idx: Int) -> CachedThumbnail
}

class ThumbnailsControllerFromContentBucket: ThumbnailsController {
    
    let contents: Contents
    let bucket: ContentBucket
    
    init (contents: Contents, bucket: ContentBucket) {
        self.contents = contents
        self.bucket = bucket
    }
    
    var contentCount: Int {
        return bucket.contents.count
    }
    
    func getThumbnail (idx: Int) -> CachedThumbnail {
        return bucket.contents [idx].thumbnail
    }
}
