//
//  ImageContent.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

final class ImageContent: ContentBase, Content {
    static let contentType = ContentType (
        name: "Images",
        fileTypes: Set<String> (["jpg", "jpeg", "png", "tiff", "gif", "heic"]),
        bucketDefinitions: [
            (name: "Photos", fileTypes: Set<String> (["jpg", "jpeg", "png", "heic"])),
            (name: "Animated", fileTypes: Set<String> (["gif"]))],
        contentClass: ImageContent.self)
    
    func getThumbnailCGImage (folderURL: URL) -> CGImage? {
        let url = folderURL.appendingPathComponent(fileName)
        if let source = CGImageSourceCreateWithURL(url as CFURL, nil) {
            let options: [NSString: AnyObject] = [
                kCGImageSourceCreateThumbnailFromImageAlways: kCFBooleanTrue,
                kCGImageSourceThumbnailMaxPixelSize: 200 as CFNumber,
                kCGImageSourceShouldCache: kCFBooleanFalse
            ]
            return CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary)
         }
        return nil
    }

}
