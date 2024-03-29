//
//  ContentProvider.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

enum ContentProviderError: Error {
    case invalid
}

//=================================================================================
/// The ContentProvider class provides methods to enumerate files in a folder, and
/// add registered file types to content sections and buckets
class ContentProvider {
    
    private let registeredContentTypes : [ContentType]
    
    //----------------------------------------------------------------------------
    /// init
    ///
    /// - Parameter registeredContentTypes: An array of ContentType structures describing
    ///                                     content we support.
    init (registeredContentTypes: [ContentType]) {
        self.registeredContentTypes = registeredContentTypes
    }
    
    //----------------------------------------------------------------------------
    /// loadContentsIntoSections
    ///
    /// - Parameter folderUrl: The URL to load contents from
    /// - Returns: An array of content sections with buckets of supported content.
    /// - Throws: Propagates errors from File Manager
    func loadContentsIntoSections (folderUrl: URL, deleted: Bool) throws -> [ContentSection] {
        let files = deleted 
        ? FastDirectoryEnumerator (path: folderUrl.path).getDeletedFiles(recurse: true)
        : FastDirectoryEnumerator (path: folderUrl.path).getFiles(recurse: true, ignoringSubdirs: ["deleted", "originals"])
 
        // Create a content section for each registered content type where at least one content url exists for it.
        return registeredContentTypes.reduce(into: [ContentSection]()) {sectionSum, contentType in

            var i = 0

            // Create sectionMap - an array of indexes into urls with content support by contentType
            let sectionMap = files.reduce(into: [Int]()) {intSum, filename in
                

                let ns = NSString (string: filename).pathExtension.lowercased()

                if contentType.fileTypes.contains(ns) {
                    intSum.append(i)
                }
                i += 1
            }

            if sectionMap.count > 0 {

                // If there are any contents availabel for this content type, create an array of the contents
                let contents = sectionMap.map {idx -> Content in
                    let relativeFileName = files [idx]
                    return contentType.contentClass.init (fileName: relativeFileName)
                }

                sectionSum.append (ContentSection (name: contentType.name, contents: contents))
            }
        }
    }
    
    //----------------------------------------------------------------------------
    /// func getRelativeFilePath
    ///
    /// Get the file name for a URL, relative to the given folder URL
    ///
    /// - Parameters:
    ///   - url: The URL
    ///   - folderURL: The folder URL
    /// - Returns: The file path - relative to the given folder URL
    /// - Throws: ContentProviderError.invalid if the url is not in the folderURL's path
    private func getRelativeFilePath (url: URL, folderURL: URL) throws -> String {
        let folderPath = folderURL.path
        let urlPath = url.path
        
        if urlPath.starts(with: folderPath) {
            let st = String (urlPath [urlPath.index (folderPath.endIndex, offsetBy:1)..<urlPath.endIndex])
            return st
        } else {
            throw ContentProviderError.invalid
        }
    }
    
    func countFiles (url: URL) -> Int {
        
        let cx = FastDirectoryEnumerator (url: url).deepCount  (ignoringSubdirs: ["deleted", "originals"])
        return cx
    }
    
}
