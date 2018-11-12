//
//  ContentPlayer.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 12/11/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa

protocol ContentPlayerDelegate : NSObjectProtocol {
    func finished (sender: Any)
}

protocol ContentPlayer: AnyObject {
    var delegate: ContentPlayerDelegate? { get set }
    var caLayer: CALayer? { get }
    var duration: Double { get }
    var currentPosition: Double { get set }
    
    func play ()
    func stop ()
}
