//
//  ContentDeleter.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 24/12/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation


class ContentDeleterInitialCheckOp: Operation {
    let contentDeleter: ContentDeleter
    var error: Error?
    init (contentDeleter: ContentDeleter) {
        self.contentDeleter = contentDeleter
    }
    override func main() {
        do {
            try FileManager.default.createDirectory(at: contentDeleter.deletedFolderURL, withIntermediateDirectories: true, attributes: nil)
        } catch let err {
            error = err
        }
    }
}

class ContentDeleter {
    
    let contentFolderURL: URL
    let deletedFolderURL: URL
    let deletedQueue = OperationQueue ()
    
  
    init (contentFolderURL: URL) {
        self.contentFolderURL = contentFolderURL
        self.deletedFolderURL = contentFolderURL.appendingPathComponent("Deleted", isDirectory: true)
        self.deletedQueue.maxConcurrentOperationCount = 1
    }
    
    func deleteContents (contents: [Content], callback: @escaping (Error?) -> Void) {
        let checkOp = ContentDeleterInitialCheckOp (contentDeleter: self)
        checkOp.completionBlock = {
            if checkOp.error != nil {
                DispatchQueue.main.async {
                    callback (checkOp.error)
                }
                self.deletedQueue.cancelAllOperations()
            }
        }
        deletedQueue.addOperation (checkOp)
        
        contents.forEach { content in deletedQueue.addOperation { self.deleteContent(content: content) } }
        
        let finishedOp = Operation ()
        finishedOp.completionBlock = {
            callback (nil)
        }
        deletedQueue.addOperation(finishedOp)
    }
    
    private func deleteContent (content: Content) {
        try? FileManager.default.moveItem(at: contentFolderURL.appendingPathComponent(content.fileName), to: deletedFolderURL.appendingPathComponent(content.fileName))
    }
    
    private func ensureDeletedFolderExists () throws {
    }

}
