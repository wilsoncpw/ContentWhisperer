//
//  MovieContentPlayer.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 12/11/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation
import AVKit

class MovieContentPlayer: NSObject, ContentPlayer {
    weak var delegate: ContentPlayerDelegate?
    lazy var duration: Double = asset.duration.seconds
    var statusObserver: NSKeyValueObservation?
    var suggestedSize: NSSize?
    
    let asset: AVAsset
    
    var player: AVPlayer?
    
    init (asset: AVAsset) {
        self.asset = asset
        
        let item: AVPlayerItem?
        if !asset.hasProtectedContent {
            item = AVPlayerItem (asset: asset)
            player = AVPlayer (playerItem: item)
        } else {
            item = nil
        }
        
        super.init()
        
        if let item = item {
            statusObserver = item.observe(\.status, options: [.new, .old]) {[weak self] item, change in
                
                let cps: ContentPlayerStatus
                switch item.status {
                case .failed: cps = .failed
                case.readyToPlay: cps = .readyToPlay
                case .unknown: cps = .unknown
                @unknown default: fatalError()
                }
                
                if let s = self {
                    s.delegate?.statusChanged(sender: s, status: cps)
                }
            }
            
            NotificationCenter.default.addObserver(self, selector: #selector(finishVideo), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        }
    }
    
    deinit {
        statusObserver?.invalidate()
    }
    
    lazy var caLayer = getCALayer ()
    
    func getCALayer () -> CALayer? {
        
        
        
        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
        
        layer.isOpaque = true
        //        layer.contentsGravity = .resizeAspect
        layer.shadowOpacity = 1
        layer.shadowRadius = 20
        layer.videoGravity = .resizeAspect
        
        return layer
    }
    
    @objc func finishVideo()
    {
        delegate?.statusChanged(sender: self, status: .finished)
    }
    
    func play () {
        if asset.hasProtectedContent {
            return
        }
        player?.play()
    }
    
    func stop () {
        player?.pause()
    }
    
    var currentPosition: Double {
        get {
            return player?.currentTime().seconds ?? 0
        }
        set {
            let timescale = CMTimeScale (1000) // player.currentTime().timescale
            let time = CMTime (seconds: newValue, preferredTimescale: timescale)
            player?.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        }
    }
    
    var isPlaying: Bool {
        guard let player = player else { return false }
        return player.rate != 0 && player.error == nil
    }
    
    func nextPage() {
    }
    
    func prevPage() {
    }
}
