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
//    let fileName: String
//    let isRelativePath: Bool
//    lazy var displayName: String = {return (fileName as NSString).lastPathComponent} ()

    static let contentType = ContentType (
        name: "Videos",
        fileTypes: Set<String> (["m4v", "mov", "mp4"]),
        bucketDefinitions: [
            (name: "Movies", fileTypes: Set<String> (["m4v"])),
            (name: "Clips", fileTypes: Set<String> (["mov", "mp4"]))],
        contentClass: MovieContent.self)
    
//    init(fileName: String) {
//        self.fileName = fileName
//        self.isRelativePath = !fileName.starts(with: "/")
//    }
    
    private func getAsset (folderURL: URL) -> AVAsset {
        let url = (isRelativePath) ? folderURL.appendingPathComponent(fileName) : URL (fileURLWithPath: fileName)
        return AVAsset(url: url)
    }
    
    func getThumbnailCGImage (folderURL: URL) -> CGImage? {
        let asset = getAsset(folderURL: folderURL)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        
        let time = CMTimeMakeWithSeconds(Float64(1), preferredTimescale: 100)
        return try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
    }
    
    func getPlayer(folderURL: URL) -> ContentPlayer? {
        let asset = getAsset(folderURL: folderURL)
        return MovieContentPlayer (asset: asset)
    }
}

