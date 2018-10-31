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
    
    init (registeredContentTypes: [ContentType]) {
        self.registeredContentTypes = registeredContentTypes
    }
    
    private var supportedFileTypes: Set<String> {
        return registeredContentTypes.reduce(into: Set<String> ()) {fileTypesSum, contentType in
            fileTypesSum.formUnion(contentType.fileTypes)
        }
    }
    
    func loadContentsIntoSections (folderUrl: URL) throws -> [ContentSection] {
        let urls = try FileManager.default.contentsOfDirectory(at: folderUrl, includingPropertiesForKeys: [URLResourceKey(rawValue: URLResourceKey.nameKey.rawValue)], options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
        
        return registeredContentTypes.reduce(into: [ContentSection]()) {sectionSum, contentType in
            
            var i = 0
            let sectionMap = urls.reduce(into: [Int]()) {intSum, url in
                if contentType.fileTypes.contains(url.pathExtension.lowercased()) {
                    intSum.append(i)
                }
                i += 1
            }
            
            if sectionMap.count > 0 {
                sectionSum.append (ContentSection (name: contentType.name, contents: sectionMap.map {idx in contentType.contentClass.init (fileName: urls [idx].lastPathComponent)}))
            }
        }
    }
}
