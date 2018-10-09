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
    
    var registeredContentClasses = [Content.Type] ()
    
    var supportedFileTypes: Set<String> {
        var rv = Set<String> ()
        
        for ct in registeredContentClasses {
            rv.formUnion(ct.supportedFileTypes)
        }
        return rv
    }
    
    private init () {
        ContentProvider.registerContentType (s: self, tp: ImageContent.self)
    }
    
    static func registerContentType (s: ContentProvider, tp: Content.Type) {
        s.registeredContentClasses.append(tp)
    }
    
    
    func contentThatSupports (url: URL) -> Content? {
        for ct in registeredContentClasses {
            if ct.supportedFileTypes.contains(url.pathExtension.lowercased()) {
                return ct.init (fileName: url.lastPathComponent)
            }
        }
        return nil
    }
}
