//
//  Contents.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

//==================================================================================
/// The contents of a folder - sorted into sections and buckets
class Contents {
    let folderURL : URL
    private (set) var contentSections: [ContentSection]

    //----------------------------------------------------------------------------
    /// init
    ///
    /// - Parameters:
    ///   - contentProvider: The content provider loads the contents into content sections
    ///   - folderURL: The folder URL we want the provider load
    /// - Throws: Propagated from the content provider
    init (contentProvider: ContentProvider, folderURL: URL, deleted: Bool) throws {
        self.folderURL = folderURL
        self.contentSections = try contentProvider.loadContentsIntoSections(folderUrl: folderURL, deleted: deleted)
    }
    
    //----------------------------------------------------------------------------
    /// Delete the given content from the contentBuckets in our contentSections
    ///
    /// Returns an array containing the content that was actually deleted.  Hopefully
    /// this will be the same as the array passed in.
    ///
    /// Deleting contents from a section may cause the section to become empty - in which
    /// case it is removed
    ///
    /// - Parameter content: An array of content to delete
    /// - Returns: An array of content that was deleted.
    func deleteContent (_ content: [Content]) -> [Content] {
        var deletedSections = [Int] ()
        defer {
            for sectionIdx in deletedSections.reversed() { contentSections.remove(at: sectionIdx) }
        }
        var idx = 0
        
        return contentSections.reduce(into: [Content] ()) {accum, section in
            accum.append(contentsOf: section.removeContent(content))
            if section.buckets.count == 0 {
                deletedSections.append(idx)
            }
            idx += 1
        }
    }
}
