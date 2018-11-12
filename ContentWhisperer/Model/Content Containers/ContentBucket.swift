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
    private var filenameMap = [String:Int] ()
    
    init (name: String, initialContent: [Content]) {
        self.name = name
        self.contents = initialContent
    }
    
    func addContent (_ content: Content) {
        contents.append(content)
    }
    
    func calcFileNameMap () {
        var c = 0
        filenameMap.removeAll()
        for content in contents {
            filenameMap [content.fileName] = c
            c += 1
        }
    }
    
    func getIndexForFilename (fileName: String) -> Int? {
        return filenameMap [fileName]
    }
}
