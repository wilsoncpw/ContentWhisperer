//
//  ImageContent.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

class ImageContent: Content {
    
    let fileName: String
    static let supportedFileTypes: Set<String> = ["jpg", "jpeg", "png", "tiff", "gif", "heic"]
    
//    var fileName: String {
//        return _fileName
//    }
    
    required init (fileName: String) {
        self.fileName = fileName
    }
}
