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
    func removeThumbnails (sender: Any, idxs: Set<Int>)
    func reloadThumbnails ()
}

protocol ThumbnailsController: AnyObject {
    var contentCount: Int { get }
    var shuffled: Bool { get }
    func getThumbnail (idx: Int) -> CachedThumbnail
    func thumbnailChanged (thumbnail: CachedThumbnail)
    func getThumbnailLabel (idx: Int)->String
    func getThumbnailPathForDisplay (idx: Int)->String
    func getThumbnailURL (idx: Int) -> URL
    var delegate: ThumbnailsControllerDelegate? { get set }
    func itemRequired (idx: Int)
    func itemNotRequired (idx: Int)
    func deleteItems (_ items: Set<Int>)
    func sortContents ()
    func shuffleContents ()
}

