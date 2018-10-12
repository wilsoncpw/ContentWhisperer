//
//  MovieContent.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

class MovieContent: ContentBase, Content {
    static let name = "Videos"
    static let fileTypes = Set<String> (["m4v", "mov", "mp4"])
    static let bucketDefinitions = [
        (name: "Movies", fileTypes: Set<String> (["m4v"])),
        (name: "Clips", fileTypes: Set<String> (["mov", "mp4"]))]
}
