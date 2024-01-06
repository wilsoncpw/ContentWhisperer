//
//  ContentDeleter.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 24/12/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

//======================================================================================================
/// class ContentDeleter
///
/// The class provides the 'deleteContents' function which deletes contents in the background
///
class ContentDeleter {
    
    let contentFolderURL: URL
    let deletedFolderURL: URL
    
    private let deletedQueue = OperationQueue ()
    private var lastDeletedPathURL: URL?
    
    init (contentFolderURL: URL) {
        self.contentFolderURL = contentFolderURL
        self.deletedFolderURL = contentFolderURL.appendingPathComponent("Deleted", isDirectory: true)
        self.deletedQueue.maxConcurrentOperationCount = 1
    }
    
    //--------------------------------------------------------------------------------------------------
    /// func deleteContents
    ///
    /// 'Deletes' content by moving it into a sub-tree under contentFolderURL/Deleted
    ///
    /// - Parameters:
    ///   - contents: Array of Content to delete
    ///   - callback: Callback called when the background processing has finished
    func deleteContents (_ contents: [Content], showingDeletedContents: Bool, callback: @escaping (Error?) -> Void) {
        contents.forEach { content in
            if showingDeletedContents {
                deletedQueue.addOperation { try? self.reallyDeleteContent(content)}
            } else {
                deletedQueue.addOperation { try? self.deleteContent(content) }
            }
        }
        
        let finishedOp = Operation ()
        finishedOp.completionBlock = {
            callback (nil)
        }
        deletedQueue.addOperation(finishedOp)
    }
    
    //--------------------------------------------------------------------------------------------------
    /// func deleteContent
    ///
    /// - Parameter content: The content to delete
    /// - Throws: Exceptions from FileManager
    private func deleteContent (_ content: Content) throws {
        
        let deletedContentURL = deletedFolderURL.appendingPathComponent(content.fileName)
        
        // Note that the fileName may be a sub-folder - "test/pic.jpg" - so we want to create this structure in the Deleted folder URL
        let deletedPathURL = deletedContentURL.deletingLastPathComponent()
        
        // As a refinement, cache the last 'Deleted' sub folder, and only attempt to create it if it changes.
        if lastDeletedPathURL != deletedPathURL {
            try FileManager.default.createDirectory(at: deletedPathURL, withIntermediateDirectories: true, attributes: nil)
            lastDeletedPathURL = deletedPathURL
        }
        
        try FileManager.default.moveItem(at: contentFolderURL.appendingPathComponent(content.fileName), to: deletedContentURL)
    }
    
    private func reallyDeleteContent (_ content: Content) throws {
        let deletedContentURL = contentFolderURL.appendingPathComponent(content.fileName)
        let deletedPathURL = deletedContentURL.deletingLastPathComponent()
        
        try FileManager.default.removeItem(at: deletedContentURL)
        if try FileManager.default.contentsOfDirectory(at: deletedPathURL, includingPropertiesForKeys: []).isEmpty {
            try FileManager.default.removeItem(at: deletedPathURL)
        }
    }
}
