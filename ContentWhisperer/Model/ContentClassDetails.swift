//
//  ContentClassDetails.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

struct ContentClassDetails {
    let contentClassType: Content.Type
    let name: String
    let fileTypes: Set<String>
    
    init (name: String, contentClassType: Content.Type, fileTypes: Set<String>) {
        self.name = name
        self.contentClassType = contentClassType
        self.fileTypes = fileTypes
    }
}
