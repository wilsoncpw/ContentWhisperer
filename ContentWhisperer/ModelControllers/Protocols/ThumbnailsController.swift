//
//  ThumbnailsController.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 13/11/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

protocol ThumbnailsControllerDelegate: NSObjectProtocol {
    func reloadThumbnail (sender: Any, idx: Int)
}

protocol ThumbnailsController: AnyObject {
    var contents: Contents { get }
    var contentCount: Int { get }
    func getThumbnail (idx: Int) -> CachedThumbnail
    func thumbnailChanged (thumbnail: CachedThumbnail)
    func getThumbnailLabel (idx: Int)->String
    var delegate: ThumbnailsControllerDelegate? { get set }
    func itemRequired (idx: Int)
    func itemNotRequired (idx: Int)
}

