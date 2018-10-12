//
//  Contents.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation


class Contents {
    let folderURL : URL
    let contentSections: [ContentSection]

    init (contentProvider: ContentProvider, folderURL: URL) throws {
        self.folderURL = folderURL
        self.contentSections = try contentProvider.loadContentsIntoSections(folderUrl: folderURL)
    }

}
