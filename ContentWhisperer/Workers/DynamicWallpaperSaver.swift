//
//  DynamicWallpaperSaver.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 02/02/2021.
//  Copyright © 2021 Colin Wilson. All rights reserved.
//

import Foundation
import AVFoundation

enum DynamicWallpaperSaverError: LocalizedError {
    case badDestination
    case badTag
    case badFinalize
    
    public var errorDescription: String? {
        switch self {
        case .badDestination: return "Can't create image destination"
        case .badTag: return "Bad Tag"
        case .badFinalize: return "Unable to finalize image"
        }
    }}

class DynamicWallpaperSaver {
    let lightImage: CGImage
    let darkImage: CGImage
    
    init (lightImage: CGImage, darkImage: CGImage) {
        self.lightImage = lightImage
        self.darkImage = darkImage
    }
    
    func saveTo (url: URL) throws {
        
        guard let imageDestination = CGImageDestinationCreateWithURL(url as CFURL, AVFileType.heic as CFString, 2, nil) else {
            throw DynamicWallpaperSaverError.badDestination
        }
        
        struct Metadata: Codable {
            public let darkIdx: Int
            public let lightIdx: Int
            
            private enum CodingKeys: String, CodingKey {
                case darkIdx = "d"
                case lightIdx = "l"
            }
        }
        
        let encoder = PropertyListEncoder ()
        encoder.outputFormat = .binary
        let metadata = Metadata (darkIdx: 1, lightIdx: 0)
        let metadataBase64String = try encoder.encode(metadata).base64EncodedString()
        
        let imageMetadata = CGImageMetadataCreateMutable()
        
        guard
            let tag = CGImageMetadataTagCreate(
                "http://ns.apple.com/namespace/1.0/" as CFString,        // xmlns
                "apple_desktop" as CFString,                             // prefix
                "apr" as CFString,                                       // name
                .string,                                                 // type
                metadataBase64String as CFString),                       // value
            CGImageMetadataSetTagWithPath(imageMetadata, nil, "xmp:apr" as CFString, tag) else {
            throw DynamicWallpaperSaverError.badTag
        }
        
        CGImageDestinationAddImageAndMetadata(imageDestination, lightImage, imageMetadata, nil)
        CGImageDestinationAddImage(imageDestination, darkImage, nil)
        
        if !CGImageDestinationFinalize(imageDestination) {
            throw DynamicWallpaperSaverError.badFinalize
        }
        
    }
}
