//
//  MovieContentController.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 12/11/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation
import AVKit

//========================================================================================
/// Error values for MovieContentController
enum MovieContentControllerError: LocalizedError {
    case ProtectedContent
    
    public var errorDescription: String? {
        switch self {
        case .ProtectedContent: return "Protected Content"
        }
    }
}

//========================================================================================
/// MovieContentController
class MovieContentController: ContentController, ContentPlayer {
    weak var delegate: ContentPlayerDelegate?               // ContentPlayer protocol
    lazy var duration: Double = asset.duration.seconds      //      "           "
    var suggestedSize: NSSize?                              // ContentController protocol
    lazy var caLayer = getCALayer ()                        //      "           "
    
    let asset: AVAsset  // The AVAsset
    
    private var statusObserver: NSKeyValueObservation?
    private let item: AVPlayerItem
    private lazy var player = AVPlayer (playerItem: item)
    
    //----------------------------------------------------------------------------------------
    /// init - Constructor for MovieContentController
    /// - Parameter asset: The movie AVAsset
    /// - Throws: MoveContentControllerError
    init (asset: AVAsset) throws {
        self.asset = asset
        
        guard !asset.hasProtectedContent else {
            throw MovieContentControllerError.ProtectedContent
        }
        
        item = AVPlayerItem (asset: asset)
                        
        // Observe the player item for status changes
        statusObserver = item.observe(\.status, options: [.new, .old]) {[weak self] item, change in
            
            let cps: ContentPlayerStatus
            switch item.status {
            case .failed: cps = .failed
            case.readyToPlay: cps = .readyToPlay
            case .unknown: cps = .unknown
            @unknown default: fatalError()
            }
            
            // Call the delegate when they occur
            if let s = self {
                s.delegate?.statusChanged(sender: s, status: cps)
            }
        }
        
        // Observe the AVPlayer's notification that its reached the end
        NotificationCenter.default.addObserver(self, selector: #selector(finishVideo), name: .AVPlayerItemDidPlayToEndTime, object: item)
    }
    
    deinit {
        statusObserver?.invalidate()
    }
    
    //----------------------------------------------------------------------------------------
    /// Backingfor the caLayer lazy variable
    /// - Returns: the CALayer for the movie's player
    private func getCALayer () -> CALayer? {
        
        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
        
        layer.isOpaque = true
        layer.shadowOpacity = 1
        layer.shadowRadius = 20
        layer.videoGravity = .resizeAspect
        
        return layer
    }
    
    //----------------------------------------------------------------------------------------
    /// Handle the notification from the observer that the movie has finished playing
    @objc private func finishVideo()
    {
        delegate?.statusChanged(sender: self, status: .finished)
    }
    
    //========================================================================================
    // ContentPlayer protocol...
    
    //----------------------------------------------------------------------------------------
    /// Start or resume playback
    func play () {
        if asset.hasProtectedContent {
            return
        }
        player.play()
    }
    
    //----------------------------------------------------------------------------------------
    /// Pause playback
    func stop () {
        player.pause()
    }
    
    //----------------------------------------------------------------------------------------
    /// Get or set the current position
    var currentPosition: Double {
        get {
            return player.currentTime().seconds
        }
        set {
            let timescale = CMTimeScale (1000)
            let time = CMTime (seconds: newValue, preferredTimescale: timescale)
            player.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        }
    }
    
    //----------------------------------------------------------------------------------------
    /// Returns true if the content is playing
    var isPlaying: Bool {
        return player.rate != 0 && player.error == nil
    }
    
    //========================================================================================
    // ContentController protocol...
    
    //----------------------------------------------------------------------------------------
    /// Take a snapshot of the movie at its current position
    /// - Returns: The snapshot CGImage
    func takeSnaphot () throws -> CGImage? {
        
        let generator = AVAssetImageGenerator (asset: asset)
        generator.requestedTimeToleranceAfter = CMTime.zero
        generator.requestedTimeToleranceBefore = CMTime.zero
        
        return try generator.copyCGImage(at: player.currentTime(), actualTime: nil)
    }
}
