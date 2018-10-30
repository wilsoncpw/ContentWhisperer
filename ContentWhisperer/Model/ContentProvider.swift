//
//  ContentProvider.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

class ContentProvider {
    
    private let registeredContentTypes : [ContentType]
    
    var supportedFileTypes: Set<String> {
        return registeredContentTypes.reduce(Set<String> ()) {fileTypesSum, contentType in
            fileTypesSum.union(contentType.fileTypes)
        }
    }
    
    init (registeredContentTypes: [ContentType]) {
        self.registeredContentTypes = registeredContentTypes
        print (supportedFileTypes)
    }
    
    func loadContentsIntoSections (folderUrl: URL) throws -> [ContentSection] {
        let urls = try FileManager.default.contentsOfDirectory(at: folderUrl, includingPropertiesForKeys: [URLResourceKey(rawValue: URLResourceKey.nameKey.rawValue)], options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
        
        return registeredContentTypes.reduce([ContentSection]()) {sectionSum, contentType in
            
            var i = 0
            let sectionMap = urls.reduce([Int]()) {intSum, url in
                let rv = contentType.fileTypes.contains(url.pathExtension.lowercased()) ? intSum + [i] : intSum
                i += 1
                return rv
            }
            
            return sectionMap.count > 0
                ? sectionSum + [ContentSection (name: contentType.name, contents: sectionMap.map {idx in contentType.contentClass.init (fileName: urls [idx].lastPathComponent)})]
                : sectionSum
        }
    }
}
