//
//  ContentBase.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

protocol Content {
    init (fileName: String)
    var fileName: String { get }
    static var fileTypes:Set<String> { get }
    static var name: String { get }
    static var bucketDefinitions: [(name: String, fileTypes: Set<String>)] { get }
}

class ContentBase {
    let fileName: String

    required init (fileName: String) {
        self.fileName = fileName
    }
}
