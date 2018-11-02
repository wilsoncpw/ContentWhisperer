//
//  MovieContent.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa
import AVKit

final class MovieContent: ContentBase, Content {
    static let contentType = ContentType (
        name: "Videos",
        fileTypes: Set<String> (["m4v", "mov", "mp4"]),
        bucketDefinitions: [
            (name: "Movies", fileTypes: Set<String> (["m4v"])),
            (name: "Clips", fileTypes: Set<String> (["mov", "mp4"]))],
        contentClass: MovieContent.self)
    
    func getThumbnailCGImage (folderURL: URL) -> CGImage? {
        let asset = AVAsset(url: folderURL.appendingPathComponent(fileName))
        
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        
        let time = CMTimeMakeWithSeconds(Float64(1), preferredTimescale: 100)
        return try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
    }
    
    func getDisplayLayer (folderURL: URL) -> CALayer? {
        
        // initialize the video player with the url
        let player = AVPlayer(url: folderURL.appendingPathComponent(fileName))
        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
        
        layer.isOpaque = true
        layer.contentsGravity = .resizeAspect
        layer.shadowOpacity = 1
        layer.shadowRadius = 20
        layer.videoGravity = .resizeAspectFill
        
        player.play()
        
        return layer
    }

}
