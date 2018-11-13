//
//  ContentBucket.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 01/11/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation


class ContentBucket {
    let name: String
    private (set) var contents : [Content]
    private var _filenameMap : [String:Int]?
    
    init (name: String, initialContent: [Content]) {
        self.name = name
        self.contents = initialContent
    }
    
    func addContent (_ content: Content) {
        contents.append(content)
        _filenameMap = nil
    }
    
    private var filenameMap: [String: Int] {
        if _filenameMap == nil {
            var c = 0
            _filenameMap = contents.reduce(into: [String:Int]()) {accum, content in
                accum [content.fileName] = c
                c += 1
            }
        }
        return _filenameMap!
    }
    
    func getIndexForFilename (fileName: String) -> Int? {
        return filenameMap [fileName]
    }
}
