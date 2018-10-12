//
//  ContentProvider.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

class ContentProvider {
    
    private let registeredContentClasses : [Content.Type]
    
    var supportedFileTypes: Set<String> {
        return registeredContentClasses.reduce(Set<String> ()) {fileTypesSum, contentType in
            fileTypesSum.union(contentType.fileTypes)
        }
    }
    
    init (registeredContentClasses: [Content.Type]) {
        self.registeredContentClasses = registeredContentClasses
        print (supportedFileTypes)
    }
    
    func loadContentsIntoSections (folderUrl: URL) throws -> [ContentSection] {
        let urls = try FileManager.default.contentsOfDirectory(at: folderUrl, includingPropertiesForKeys: [URLResourceKey(rawValue: URLResourceKey.nameKey.rawValue)], options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
        
        return registeredContentClasses.reduce([ContentSection]()) {sectionSum, contentType in
            
            var i = 0
            let sectionMap = urls.reduce([Int]()) {intSum, url in
                let rv = contentType.fileTypes.contains(url.pathExtension.lowercased()) ? intSum + [i] : intSum
                i += 1
                return rv
            }
            
            return sectionMap.count > 0
                ? sectionSum + [ContentSection (name: contentType.name, contents: sectionMap.map {idx in contentType.init (fileName: urls [idx].lastPathComponent)})]
                : sectionSum
        }
    }
}
