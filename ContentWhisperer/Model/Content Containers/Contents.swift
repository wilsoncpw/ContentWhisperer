//
//  Contents.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

///=================================================================================
/// The contents of a folder - sorted into sections and buckets
class Contents {
    let folderURL : URL
    let contentSections: [ContentSection]

    ///----------------------------------------------------------------------------
    /// init
    ///
    /// - Parameters:
    ///   - contentProvider: The content provider loads the contents into content sections
    ///   - folderURL: The folder URL we want the provider load
    /// - Throws: Propagated from the content provider
    init (contentProvider: ContentProvider, folderURL: URL) throws {
        self.folderURL = folderURL
        self.contentSections = try contentProvider.loadContentsIntoSections(folderUrl: folderURL)
    }
}
