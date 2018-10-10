//
//  ContentProvider.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

class ContentProvider {
    static let instance = ContentProvider ()
    
    var registeredContentClasses = [ContentClassDetails] ()
    
    var fileTypes: Set<String> {
        var rv = Set<String> ()
        
        for contentClass in registeredContentClasses {
            rv.formUnion(contentClass.fileTypes)
        }
        return rv
    }
    
    private init () {
        ContentProvider.registerContentType (s: self, name: "Photos", contentClassType: ImageContent.self, fileTypes: ["jpg", "jpeg", "png", "tiff", "gif", "heic"])
        ContentProvider.registerContentType(s: self, name: "Videos", contentClassType: MovieContent.self, fileTypes: ["m4v", "mov", "mp4"])
    }
    
    static func registerContentType (s: ContentProvider, name: String, contentClassType: Content.Type, fileTypes: Set<String>) {
        s.registeredContentClasses.append(ContentClassDetails (name: name, contentClassType: contentClassType, fileTypes: fileTypes))
    }
    
    func contentThatSupports (url: URL) -> (typeName:String, content:Content)? {
        for contentClassDetails in registeredContentClasses {
            if contentClassDetails.fileTypes.contains(url.pathExtension.lowercased()) {
                return (contentClassDetails.name, contentClassDetails.contentClassType.init (fileName: url.lastPathComponent))
            }
        }
        return nil
    }
}
