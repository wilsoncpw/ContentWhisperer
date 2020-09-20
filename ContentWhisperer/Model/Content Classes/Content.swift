//
//  ContentBase.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa
import AVKit

typealias BucketDefinition = (name: String, fileTypes: Set<String>)

//=================================================================================
/// ContentType.  Each content class provides a static one of these, which is used to register with the content provider
struct ContentType {
    let fileTypes:Set<String>
    let name: String
    let bucketDefinitions: [BucketDefinition]
    let contentClass: Content.Type
    
    init (name: String, fileTypes: Set<String>, bucketDefinitions: [(name: String, fileTypes: Set<String>)], contentClass: Content.Type) {
        self.name = name
        self.fileTypes = fileTypes
        self.bucketDefinitions = bucketDefinitions
        self.contentClass = contentClass
    }
}

protocol ContentBaseProtocol: AnyObject {
    init (fileName: String)
    var fileName: String { get }
    var displayName: String { get }
    func getURL (folderURL: URL)-> URL
}

//=================================================================================
/// Content protocol
protocol Content : ContentBaseProtocol {
    static var contentType: ContentType { get }
    func getThumbnailCGImage (folderURL: URL) -> CGImage?
    func getPlayer (folderURL: URL) -> ContentPlayer?
}

class ContentBase: ContentBaseProtocol {
    let fileName: String
    let isRelativePath: Bool
    lazy var displayName: String = {return (fileName as NSString).lastPathComponent} ()
    
    required init(fileName: String) {
        self.fileName = fileName
        self.isRelativePath = !fileName.starts(with: "/")
    }
    func getURL (folderURL: URL)-> URL {
        return (isRelativePath) ? folderURL.appendingPathComponent(fileName) : URL (fileURLWithPath: fileName)
    }

}


