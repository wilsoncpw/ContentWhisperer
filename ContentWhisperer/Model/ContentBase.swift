//
//  ContentBase.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

class CachedThumbnail {
    
}

protocol Content {
    static var contentType: ContentType { get }
    init (fileName: String)
    var fileName: String { get }
    var thumbnail: CachedThumbnail { get }
}

/*class ContentBase {
    let fileName: String

    required init (fileName: String) {
        self.fileName = fileName
    }
}
 */
