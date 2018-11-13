//
//  CALayerControllerFromContentBucket.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 02/11/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa


class PlayerControllerFromContentBucket: PlayerController {
    let contents: Contents
    let bucket: ContentBucket

    init (contents: Contents, bucket: ContentBucket) {
        self.contents = contents
        self.bucket = bucket
    }
    
    var contentCount: Int {
        return bucket.contents.count
    }
    
    func getContentPlayer (idx: Int) -> ContentPlayer? {
        let content = bucket.contents [idx]

        return content.getPlayer(folderURL: contents.folderURL)
    }
}
