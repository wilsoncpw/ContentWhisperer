//
//  ContentSection.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 10/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

class ContentSection {
    let name: String;
    let contents: [Content]
    
    init (name: String, contents: [Content]) {
        self.name = name
        self.contents = contents
    }
    
}
