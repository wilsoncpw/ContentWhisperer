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
    private var player: AVPlayer?
    
    var _duration: Double?
    
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
    
    func getPlayer(folderURL: URL) -> ContentPlayer? {
        if _duration == nil {
            let asset = AVAsset(url: folderURL.appendingPathComponent(fileName))
            _duration = asset.duration.seconds
        }
        return MovieContentPlayer (player: AVPlayer (url: folderURL.appendingPathComponent(fileName)), duration: _duration!)
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

class MovieContentPlayer: NSObject, ContentPlayer {
    var delegate: ContentPlayerDelegate?
    let duration: Double
    
    let player: AVPlayer
    
    init (player: AVPlayer, duration: Double) {
        self.player = player
        self.duration = duration
    }
    
    deinit {
        print ("MoveContentPlayer deinit")
        player.removeObserver(self, forKeyPath: "status")
    }
    
    lazy var caLayer = getCALayer ()
    
    func getCALayer () -> CALayer? {
        
        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
        
        layer.isOpaque = true
//        layer.contentsGravity = .resizeAspect
        layer.shadowOpacity = 1
        layer.shadowRadius = 20
        layer.videoGravity = .resizeAspect
        
        player.addObserver(self, forKeyPath: "status", options:NSKeyValueObservingOptions(), context: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(finishVideo), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        return layer
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            let st = player.status
            
            switch st {
            case .failed: print ("Status: failed")
            case .readyToPlay: print ("Status: ready to play")
            case .unknown: print ("Status: Unknown")
            }
        }
    }
    
    @objc func finishVideo()
    {
        delegate?.finished()
    }
    
    func play () {
        player.play()
    }
    
    func stop () {
        player.pause()
    }
    
    var currentPosition: Double {
        get {
            return player.currentTime().seconds
        }
        set {
            let timescale = CMTimeScale (1000) // player.currentTime().timescale
            let time = CMTime (seconds: newValue, preferredTimescale: timescale)
            player.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        }
    }
}
