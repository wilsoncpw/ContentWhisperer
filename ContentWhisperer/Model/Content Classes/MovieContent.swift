//
//  MovieContent.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation
import AVKit

final class MovieContent: ContentBase, Content {

    static let contentType = ContentType (
        name: "Videos",
        fileTypes: Set<String> (["m4v", "mov", "mp4", "dv"]),
        bucketDefinitions: [
            (name: "Movies", fileTypes: Set<String> (["m4v"])),
            (name: "Clips", fileTypes: Set<String> (["mov", "mp4", "dv"]))],
        contentClass: MovieContent.self)
      
    private func getAsset (folderURL: URL) -> AVAsset {
        let url = (isRelativePath) ? folderURL.appendingPathComponent(fileName) : URL (fileURLWithPath: fileName)
        let rv = AVAsset(url: url)
        return rv

    }
    
    func getThumbnailCGImage (folderURL: URL) -> CGImage? {
        let asset = getAsset(folderURL: folderURL)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        
        if asset.hasProtectedContent {
            return nil
        }

        assetImgGenerate.appliesPreferredTrackTransform = true
        
        let time = CMTimeMakeWithSeconds(Float64(1), preferredTimescale: 100)
        return try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
    }
    
    func getPlayer(folderURL: URL) -> ContentPlayer? {
        let asset = getAsset(folderURL: folderURL)
        return MovieContentPlayer (asset: asset)
    }
}

