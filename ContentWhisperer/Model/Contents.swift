//
//  Contents.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

protocol Content {
    init (fileName: String)
    var fileName: FileName { get }
}

typealias FileName=String

struct Section {
    private weak var contents: Contents!
    let name: String
    private let indices: [Int]
    
    init (contents: Contents, name: String, indices: [Int]) {
        self.contents = contents
        self.name = name
        self.indices = indices
    }
    
    var contentsCount: Int {
        return indices.count
    }
    
    func getContent (idx: Int) -> Content {
        return contents.contents [indices [idx]]
    }
}

class Contents {
    let folderURL : URL
    fileprivate var contents: [Content]
    private var filenameMap = [FileName:Int] ()
    private var sections = [Section] ()

    init (folderURL: URL) throws{
        self.folderURL = folderURL
        var isDir : ObjCBool = false
        let contentProvider = ContentProvider.instance
        if !FileManager.default.fileExists(atPath: folderURL.path, isDirectory: &isDir) {
            contents = [Content] ()
        } else {
            let fileNames = try Contents.loadFolder (url: folderURL, allowedFileTypes: contentProvider.fileTypes)
            let contentTuples = fileNames.map {
                fileName in
                return contentProvider.contentThatSupports(url: folderURL.appendingPathComponent(fileName))
                }.compactMap { $0 }
            contents = contentTuples.map {
                tuple in
                return tuple.content
            }
            
            calcFilenameMap()
            calcSections (tuples: contentTuples)
        }
    }
    
    var sectionCount: Int {
        return sections.count
    }
    
    func getSection (idx: Int) -> Section {
        return sections [idx]
    }
    
    //-----------------------------------------------------------------------------------
    // loadFolder
    private static func loadFolder (url: URL, allowedFileTypes: Set<String>) throws -> [FileName] {
        let imageURLs = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: [URLResourceKey(rawValue: URLResourceKey.nameKey.rawValue)], options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
        let urls = imageURLs.filter {
            url in
            return allowedFileTypes.contains(url.pathExtension.lowercased())
        }
        
        return urls.map {
            url -> String in
            return url.lastPathComponent
            }.sorted(by: ) {
                fileName1, fileName2 in
                return fileName1 < fileName2
        }
    }
    
    //-----------------------------------------------------------------------------------
    // calcFilenameMap
    //
    // The filename map is a dictionary of filenames and their indexes - used to quickly
    // find the index for a given file.
    private func calcFilenameMap () {
        var c = 0
        filenameMap.removeAll()
        for content in contents {
            filenameMap [content.fileName] = c
            c += 1
        }
    }
    
    private func calcSections (tuples: [(typeName: String, content: Content)]) {
        var c = 0
        var contentTypeMap = [String:[Int]] ()
        for tuple in tuples {
            
            if contentTypeMap [tuple.typeName] == nil {
                contentTypeMap [tuple.typeName] = [Int] ([c])
            } else {
                contentTypeMap [tuple.typeName]?.append(c)
            }
            
            c += 1
        }
        
        sections.removeAll()
        for contentClassDetails in ContentProvider.instance.registeredContentClasses {
            if let arr = contentTypeMap [contentClassDetails.name] {
                sections.append(Section (contents: self, name: contentClassDetails.name, indices: arr))
            }
        }
    }
}
