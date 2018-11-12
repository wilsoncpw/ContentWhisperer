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
    private var _duration: Double?
    private var player: AVPlayer?
    
    static let contentType = ContentType (
        name: "Videos",
        fileTypes: Set<String> (["m4v", "mov", "mp4"]),
        bucketDefinitions: [
            (name: "Movies", fileTypes: Set<String> (["m4v"])),
            (name: "Clips", fileTypes: Set<String> (["mov", "mp4"]))],
        contentClass: MovieContent.self)
    
    func getThumbnailCGImage (folderURL: URL) -> CGImage? {
        let asset = AVAsset(url: folderURL.appendingPathComponent(fileName))
        
        _duration = asset.duration.seconds
        
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        
        let time = CMTimeMakeWithSeconds(Float64(1), preferredTimescale: 100)
        return try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
    }
    
    func getDisplayLayer (folderURL: URL) -> CALayer? {
        
        // initialize the video player with the url
        let player = AVPlayer(url: folderURL.appendingPathComponent(fileName))
        
        if _duration == nil {
            _duration = player.currentItem?.duration.seconds
        }
        
        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
        
        layer.isOpaque = true
        // layer.contentsGravity = .resizeAspect
        layer.shadowOpacity = 1
        layer.shadowRadius = 20
        layer.videoGravity = .resizeAspectFill
        
        NotificationCenter.default.addObserver(self, selector: #selector(finishVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        self.player = player

        player.play()
        
        
        return layer
    }
    
    @objc func finishVideo()
    {
        self.player = nil
    }
    
    var duration: Double {
        return _duration ?? 0
    }
    
    var currentPosition: Double {
        get {
            return player?.currentTime().seconds ?? 0
        }
        set {
            let time = CMTime (seconds: newValue, preferredTimescale: 1)
            player?.seek(to: time)
        }
    }
    
    func finished () {
        self.player = nil
    }
    
}
