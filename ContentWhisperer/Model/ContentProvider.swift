//
//  ContentProvider.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

class ContentProvider {
    
    private let registeredContentClasses : [ContentClassDetails]
    
    var supportedFileTypes: Set<String> {
        return registeredContentClasses.reduce(Set<String> ()) {fileTypesSum,contentClassDetails in
            fileTypesSum.union(contentClassDetails.fileTypes)
        }
    }
    
    init (registeredContentClasses: [ContentClassDetails]) {
        self.registeredContentClasses = registeredContentClasses
        print (supportedFileTypes)
    }
    
    func loadContentsIntoSections (folderUrl: URL) throws -> [ContentSection] {
        let urls = try FileManager.default.contentsOfDirectory(at: folderUrl, includingPropertiesForKeys: [URLResourceKey(rawValue: URLResourceKey.nameKey.rawValue)], options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
        
        return registeredContentClasses.reduce([ContentSection]()) {sectionSum, contentClassDetails in
            
            var i = 0
            let sectionMap = urls.reduce([Int]()) {intSum, url in
                let rv = contentClassDetails.fileTypes.contains(url.pathExtension.lowercased()) ? intSum + [i] : intSum
                i += 1
                return rv
            }
            
            return sectionMap.count > 0
                ? sectionSum + [ContentSection (name: contentClassDetails.name, contents: sectionMap.map {idx in contentClassDetails.contentClassType.init (fileName: urls [idx].lastPathComponent)})]
                : sectionSum
        }
    }
}
