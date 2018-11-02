//
//  MovieContent.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa

final class MovieContent: ContentBase, Content {
    static let contentType = ContentType (
        name: "Videos",
        fileTypes: Set<String> (["m4v", "mov", "mp4"]),
        bucketDefinitions: [
            (name: "Movies", fileTypes: Set<String> (["m4v"])),
            (name: "Clips", fileTypes: Set<String> (["mov", "mp4"]))],
        contentClass: MovieContent.self)
    
    func getThumbnailCGImage (folderURL: URL) -> CGImage? {
        return nil
    }
    
    func getDisplayLayer (folderURL: URL) -> CALayer? {
        return nil
    }

}
