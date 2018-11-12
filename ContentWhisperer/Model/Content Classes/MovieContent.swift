//
//  MovieContent.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation
import AVKit

final class MovieContent: Content {
    let fileName: String
    
    var _duration: Double?
    
    static let contentType = ContentType (
        name: "Videos",
        fileTypes: Set<String> (["m4v", "mov", "mp4"]),
        bucketDefinitions: [
            (name: "Movies", fileTypes: Set<String> (["m4v"])),
            (name: "Clips", fileTypes: Set<String> (["mov", "mp4"]))],
        contentClass: MovieContent.self)
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    @discardableResult private func getAsset (folderURL: URL) -> AVAsset {
        let asset = AVAsset(url: folderURL.appendingPathComponent(fileName))
        _duration = asset.duration.seconds
        return asset
    }
    
    func getThumbnailCGImage (folderURL: URL) -> CGImage? {
        let asset = getAsset(folderURL: folderURL)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        
        let time = CMTimeMakeWithSeconds(Float64(1), preferredTimescale: 100)
        return try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
    }
    
    func getPlayer(folderURL: URL) -> ContentPlayer? {
        if _duration == nil {
            getAsset (folderURL: folderURL)
        }
        return MovieContentPlayer (player: AVPlayer (url: folderURL.appendingPathComponent(fileName)), duration: _duration!)
    }
}

