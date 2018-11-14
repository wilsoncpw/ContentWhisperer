//
//  ContentProvider.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

///=================================================================================
/// The ContentProvider class provides methods to enumerate files in a folder, and
/// add registered file types to content sections and buckets
class ContentProvider {
    
    private let registeredContentTypes : [ContentType]
    
    ///----------------------------------------------------------------------------
    /// init
    ///
    /// - Parameter registeredContentTypes: An array of ContentType structures describing
    ///                                     content we support.
    init (registeredContentTypes: [ContentType]) {
        self.registeredContentTypes = registeredContentTypes
    }
    
    ///----------------------------------------------------------------------------
    /// loadContentsIntoSections
    ///
    /// - Parameter folderUrl: The URL to load contents from
    /// - Returns: An array of content sections with buckets of supported content.
    /// - Throws: Propagates errors from File Manager
    func loadContentsIntoSections (folderUrl: URL) throws -> [ContentSection] {
        let urls = try FileManager.default.contentsOfDirectory(at: folderUrl, includingPropertiesForKeys: [.nameKey], options: .skipsHiddenFiles)
        
        return registeredContentTypes.reduce(into: [ContentSection]()) {sectionSum, contentType in
            
            var i = 0
            
            // Create sectionMap - an array of indexes into urls with content support by contentType
            let sectionMap = urls.reduce(into: [Int]()) {intSum, url in
                if contentType.fileTypes.contains(url.pathExtension.lowercased()) {
                    intSum.append(i)
                }
                i += 1
            }
            
            
            if sectionMap.count > 0 {
                
                // Add a content section for this contentType - if there's at leat one URL that the section supports
                sectionSum.append (ContentSection (name: contentType.name, contents: sectionMap.map {idx in contentType.contentClass.init (fileName: urls [idx].lastPathComponent)}))
            }
        }
    }
}
