//
//  ContentClassDetails.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

private struct ContentClassDetails {
    let contentClassType: Content.Type
    let name: String
    
    init (name: String, contentClassType: Content.Type) {
        self.name = name
        self.contentClassType = contentClassType
    }
}
