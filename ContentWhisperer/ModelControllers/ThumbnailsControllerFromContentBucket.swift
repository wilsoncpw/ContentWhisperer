//
//  ThumbnailsCollectionFromContentBucket.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 31/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

protocol ThumbnailsControllerDelegate: AnyObject {
    func reloadThumbnail (sender: Any, idx: Int)
}

protocol ThumbnailsController: AnyObject {
    var contents: Contents { get }
    var contentCount: Int { get }
    func getThumbnail (idx: Int) -> CachedThumbnail
    func thumbnailChanged (thumbnail: CachedThumbnail)
    func getThumbnailLabel (idx: Int)->String
    var delegate: ThumbnailsControllerDelegate? { get set }
    func itemRequired (idx: Int)
    func itemNotRequired (idx: Int)
}

class IntHolder {
    var c = 0
}

class ThumbnailsControllerFromContentBucket: ThumbnailsController {
    
    let contents: Contents
    let bucket: ContentBucket
    lazy var thumbnailLoader = ThumbnailLoader (controller: self)
    weak var delegate: ThumbnailsControllerDelegate?
    var requiredItems = [String:IntHolder] ()

    
    init (contents: Contents, bucket: ContentBucket) {
        self.contents = contents
        self.bucket = bucket
    }
    
    var contentCount: Int {
        return bucket.contents.count
    }
    
    func getThumbnail (idx: Int) -> CachedThumbnail {
        let content = bucket.contents [idx]
        let thumbnail = CachedThumbnail (folderURL: contents.folderURL, content: content)
        thumbnailLoader.loadThumbnailImage(thumbnail: thumbnail)
        return thumbnail
    }
    
    func thumbnailChanged (thumbnail: CachedThumbnail) {
        if let idx = bucket.getIndexForFilename(fileName: thumbnail.content.fileName) {
            delegate?.reloadThumbnail(sender: self, idx: idx)
        }
    }
    
    //-----------------------------------------------------------------------------------
    func getThumbnailLabel (idx: Int)->String {
        return bucket.contents [idx].fileName
    }
    
    func itemRequired (idx: Int) {
        let fileName = bucket.contents [idx].fileName
        if let c = requiredItems [fileName] {
            c.c += 1
        } else {
            requiredItems [fileName] = IntHolder ()
        }
    }
    
    func itemNotRequired (idx: Int) {
        if idx >= bucket.contents.count {
            // Can happen when the delegate changes (when new images are loaded)
            // The view controller will call this for each of the previous images
            // - which won't exist in the new set.  In thiscase, either this test will
            // fail, or the new filename won't be required in requiredItems - either
            // way - we're good.
            return
        }
        
        let fileName = bucket.contents [idx].fileName
        
        if let c = requiredItems [fileName] {
            if c.c > 0 {
                c.c -= 1
            } else {
                requiredItems.removeValue(forKey: fileName)
                thumbnailLoader.cancelPendingDownload(fileName: fileName)
            }
        }
    }
    
}
