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
        delegate?.finished(sender: self)
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
