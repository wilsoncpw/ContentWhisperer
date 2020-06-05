//
//  ContentPlayer.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 12/11/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa

enum ContentPlayerStatus {
    case readyToPlay
    case failed
    case unknown
    case finished
}

protocol ContentPlayerDelegate : NSObjectProtocol {
    func statusChanged (sender: Any, status : ContentPlayerStatus)
}

protocol ContentPlayer: AnyObject {
    var delegate: ContentPlayerDelegate? { get set }
    var caLayer: CALayer? { get }
    var duration: Double { get }
    var currentPosition: Double { get set }
    var isPlaying: Bool { get }
    var suggestedSize: NSSize? { get set }
    
    func play ()
    func stop ()
    func nextPage ()
    func prevPage ()
    
    func takeSnaphot () -> CGImage?
}
