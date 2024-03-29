//
//  ImageContent.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa

final class ImageContent: ContentBase, Content {
    
    static let contentType = ContentType (
        name: "Images",
        fileTypes: Set<String> (["jpg", "jpeg", "png", "tiff", "gif", "heic", "arw", "pef", "webp"]),
        bucketDefinitions: [
            (name: "Photos", fileTypes: Set<String> (["jpg", "jpeg", "png", "heic", "arw", "pef", "webp"])),
            (name: "Animated", fileTypes: Set<String> (["gif"]))],
        contentClass: ImageContent.self)
    
    private func getImageSource (folderURL: URL) -> CGImageSource? {
        let url = getURL(folderURL: folderURL)
        return CGImageSourceCreateWithURL(url as CFURL, nil)
    }
    
    func getThumbnailCGImage (folderURL: URL) -> CGImage? {
        guard let source = getImageSource(folderURL: folderURL) else { return nil }

        let options: [NSString: AnyObject] = [
            kCGImageSourceCreateThumbnailFromImageAlways: kCFBooleanTrue,
            kCGImageSourceThumbnailMaxPixelSize: 200 as CFNumber,
            kCGImageSourceShouldCache: kCFBooleanFalse
        ]
        return CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary)
    }
    
    func getController (folderURL: URL) -> ContentController? {
        guard let source = getImageSource(folderURL: folderURL) else { return nil }
        return ImageContentController (source: source)
    }
}
