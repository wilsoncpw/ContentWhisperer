//
//  ContentType.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 29/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

struct ContentType {
    let fileTypes:Set<String>
    let name: String
    let bucketDefinitions: [(name: String, fileTypes: Set<String>)]
    let contentClass: Content.Type
    
    init (name: String, fileTypes: Set<String>, bucketDefinitions: [(name: String, fileTypes: Set<String>)], contentClass: Content.Type) {
        self.name = name
        self.fileTypes = fileTypes
        self.bucketDefinitions = bucketDefinitions
        self.contentClass = contentClass
    }
}
