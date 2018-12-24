//
//  ThumbnailsCollectionFromContentBucket.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 31/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation


class IntHolder {
    var c = 0
}

class ThumbnailsControllerFromContentBucket: ThumbnailsController {
    
    let contents: Contents
    let bucket: ContentBucket
    let deleter: ContentDeleter
    lazy var thumbnailLoader = ThumbnailLoader (controller: self)
    weak var delegate: ThumbnailsControllerDelegate?
    var requiredItems = [String:IntHolder] ()

    
    init (contents: Contents, bucket: ContentBucket) {
        self.contents = contents
        self.bucket = bucket
        self.deleter = ContentDeleter (contentFolderURL: contents.folderURL)
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
        if let idx = bucket.getIndexForFilename(thumbnail.content.fileName) {
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
    
    func deleteItems (_ items: Set<Int>) {
        let contentToDelete = items.map { idx in
            bucket.contents [idx]
        }
        
        let deletedContents = contents.deleteContent(contentToDelete)
        delegate?.removeThumbnails (sender: self, idxs: items)
        deleter.deleteContents(contents: deletedContents) { error in
            
        }
    }
}
