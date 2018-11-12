//
//  ImageContent.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

final class ImageContent: Content {
    let fileName: String
    let duration = Double (0)
    var currentPosition = Double (0)
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    static let contentType = ContentType (
        name: "Images",
        fileTypes: Set<String> (["jpg", "jpeg", "png", "tiff", "gif", "heic"]),
        bucketDefinitions: [
            (name: "Photos", fileTypes: Set<String> (["jpg", "jpeg", "png", "heic"])),
            (name: "Animated", fileTypes: Set<String> (["gif"]))],
        contentClass: ImageContent.self)
    
    private func getImageSource (folderURL: URL) -> CGImageSource? {
        return CGImageSourceCreateWithURL(folderURL.appendingPathComponent(fileName) as CFURL, nil)
    }
    
    func getThumbnailCGImage (folderURL: URL) -> CGImage? {
        if let source = getImageSource(folderURL: folderURL) {
            let options: [NSString: AnyObject] = [
                kCGImageSourceCreateThumbnailFromImageAlways: kCFBooleanTrue,
                kCGImageSourceThumbnailMaxPixelSize: 200 as CFNumber,
                kCGImageSourceShouldCache: kCFBooleanFalse
            ]
            return CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary)
         }
        return nil
    }
    
    func getPlayer (folderURL: URL) -> ContentPlayer? {
        if let source = getImageSource(folderURL: folderURL) {
            return ImageContentPlayer (source: source)
        }
        return nil
    }
}
