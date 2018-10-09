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
    static var supportedFileTypes: Set<String> { get }
}

typealias FileName=String

class Contents {
    let folderURL : URL
    private (set) var contents: [Content]
    private var filenameMap = [FileName:Int] ()

    init (folderURL: URL) throws{
        self.folderURL = folderURL
        var isDir : ObjCBool = false
        let cp = ContentProvider.instance
        if !FileManager.default.fileExists(atPath: folderURL.path, isDirectory: &isDir) {
            contents = [Content] ()
        } else {
            contents = try Contents.loadFolder(url: folderURL, allowedFileTypes: cp.supportedFileTypes).map {
                fileName in
                return cp.contentThatSupports(url: folderURL.appendingPathComponent(fileName))!
            }
            calcFilenameMap()
        }
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
                content1, content2 in
                return content1 < content2
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
}
