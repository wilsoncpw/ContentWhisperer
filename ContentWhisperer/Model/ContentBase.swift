//
//  ContentBase.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa
import AVKit

protocol Content {
    static var contentType: ContentType { get }
    init (fileName: String)
    var fileName: String { get }
    func getThumbnailCGImage (folderURL: URL) -> CGImage?
    func getPlayer (folderURL: URL) -> ContentPlayer?
}

protocol ContentPlayerDelegate : NSObjectProtocol {
    func finished ()
}

protocol ContentPlayer: AnyObject {
    var delegate: ContentPlayerDelegate? { get set }
    var caLayer: CALayer? { get }
    var duration: Double { get }
    var currentPosition: Double { get set }
    
    func play ()
    func stop ()
}

class ContentBase {
    let fileName: String

    required init (fileName: String) {
        self.fileName = fileName
    }
}
