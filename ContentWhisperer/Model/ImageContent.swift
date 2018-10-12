//
//  ImageContent.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

class ImageContent: ContentBase, Content {
    static let name = "Images"
    static let fileTypes = Set<String> (["jpg", "jpeg", "png", "tiff", "gif", "heic"])
    static let bucketDefinitions = [
        (name: "Photos", fileTypes: Set<String> (["jpg", "jpeg", "png", "heic"])),
        (name: "Animated", fileTypes: Set<String> (["gif"]))]
}
