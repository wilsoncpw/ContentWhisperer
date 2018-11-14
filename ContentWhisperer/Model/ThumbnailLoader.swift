//
//  ThumbnailLoader.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 31/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

//=======================================================================================
// class ThumbnailDownloaderOperation
class ThumbnailDownloaderOperation: Operatio
    let thumbnail: CachedThumbnail
    
    ///-----------------------------------------------------------------------------------
    /// init
    init (thumbnail: CachedThumbnail) {
        self.thumbnail = thumbnail
    }
    
    ///----------------------------------------------------------------------------------
    /// main
    override func main() {
        if !isCancelled {
            thumbnail.load()
        }
    }
}

//=======================================================================================
// class ThumbnailLoader
class ThumbnailLoader {
    let loaderQueue = OperationQueue ()           // Background image loader queue
    weak var controller : ThumbnailsController!
    var pendingDownloads = Dictionary<String, ThumbnailDownloaderOperation>()
    
    //-----------------------------------------------------------------------------------
    // init
    init (controller: ThumbnailsController) {
        self.controller = controller
        loaderQueue.maxConcurrentOperationCount = 1
    }
    
    //-----------------------------------------------------------------------------------
    // loadThumbnailImage
    //
    // Called by the ThumbnailsController to load images on a background thread.
    func loadThumbnailImage (thumbnail: CachedThumbnail) {
        
        //----------------------------------------------------------------------
        func complete (op : ThumbnailDownloaderOperation) {
            
            let thumbnail = op.thumbnail
            
            if !op.isCancelled {
                DispatchQueue.main.async {
                    self.pendingDownloads.removeValue(forKey: thumbnail.content.fileName)
                    // print ("Pending downloads: ", self.pendingDownloads.count)
                    self.controller?.thumbnailChanged (thumbnail: thumbnail)
                }
            }
        }
        
        
        //----------------------------------------------------------------------
        // Start of AsyncLoadThumbnail
        let fileName = thumbnail.content.fileName
        
        if let _ = pendingDownloads [fileName] {
            debugPrint ("Already downloading ", fileName)
            return
        }
        
        let op = ThumbnailDownloaderOperation (thumbnail: thumbnail)
        op.completionBlock = {
            complete (op: op);
        }
        
        pendingDownloads [fileName] = op
        loaderQueue.addOperation (op)
    }
    
    
    //-----------------------------------------------------------------------------------
    // cancelPendingDownload
    //
    // Called by the ThumbnailsController when it no longer needs an image.
    func cancelPendingDownload (fileName: String) {
        if let op = pendingDownloads.removeValue(forKey: fileName) {
//            print (fileName, " download cancelled. ", pendingDownloads.count, " left")
            op.cancel()
        }
        
    }
}
