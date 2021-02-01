//
//  ContentController.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 12/11/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa



protocol ContentController: AnyObject {
    var caLayer: CALayer? { get }
    func takeSnaphot () throws -> CGImage?
}

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
    var duration: Double { get }
    var currentPosition: Double { get set }
    var isPlaying: Bool { get }

    func play ()
    func stop ()
}

protocol ContentPagination: AnyObject {
    func nextPage ()
    func prevPage ()
}
