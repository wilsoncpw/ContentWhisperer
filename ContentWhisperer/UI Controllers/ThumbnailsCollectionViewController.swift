//
//  ThumbnailsCollectionViewController.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 31/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa

class ThumbnailsCollectionViewController: NSViewController, NSCollectionViewDelegate, NSCollectionViewDataSource, ThumbnailsControllerDelegate {
   
    
    @IBOutlet weak var collectionView: NSCollectionView!
    
    var thumbnailsController: ThumbnailsController? {
        willSet {
            thumbnailsController?.delegate = nil
        }
        didSet {
            thumbnailsController?.delegate = self
            focusedIdx = nil
            collectionView.reloadData()
        }
    }
    
    var focusedIdx: Int? {
        didSet {
            if focusedIdx != oldValue {
                NotificationCenter.default.post(name: .onSelectionChanged, object: focusedIdx)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
 
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbnailsController?.contentCount ?? 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let collectionViewItem = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ThumbnailsCollectionViewItem"), for: indexPath)
        
        if let tc = thumbnailsController, let cvi = collectionViewItem as? ThumbnailsCollectionViewItem {
            cvi.setImage(controller:tc, imageIdx: indexPath.item)
        }
        
        return collectionViewItem
    }
    
    func reloadThumbnail(sender: Any, idx: Int) {
        if let i = collectionView.item(at: idx) as? ThumbnailsCollectionViewItem {
            i.displayCachedThumbnail()
        }
        
    }
    
    func removeThumbnails (sender: Any, idxs: Set<Int>) {
        collectionView.deleteItems(at: Set<IndexPath> (idxs.map { idx in return IndexPath (item: idx, section: 0)}))
        NotificationCenter.default.post(name: .onThumbnailsRemoved, object: nil)
        
        guard var newFocus = focusedIdx else {
            return
        }
        
        while newFocus >= thumbnailsController?.contentCount ?? 0 {
            newFocus -= 1
        }
        
        if newFocus != focusedIdx {
            focusedIdx = newFocus == -1 ? nil : newFocus
        } else {
            NotificationCenter.default.post(name: .onSelectionChanged, object: focusedIdx)
        }
        
        if let f = focusedIdx {
            collectionView.selectionIndexes = [f]
            let item = collectionView.item(at: f) as? ThumbnailsCollectionViewItem
            item?.setHighlight(selected: true)
        } else {
            collectionView.selectionIndexes = []
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, willDisplay item: NSCollectionViewItem, forRepresentedObjectAt indexPath: IndexPath) {
        thumbnailsController?.itemRequired(idx: indexPath.item)
    }
    
    func collectionView(_ collectionView: NSCollectionView, didEndDisplaying item: NSCollectionViewItem, forRepresentedObjectAt indexPath: IndexPath) {
        thumbnailsController?.itemNotRequired(idx: indexPath.item)
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        for path in indexPaths {
            (collectionView.item(at: path) as? ThumbnailsCollectionViewItem)?.setHighlight(selected: true)
        }
        focusedIdx = collectionView.selectionIndexes.first
    }
    
    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        indexPaths.forEach() {
            path in
            (collectionView.item(at: path) as? ThumbnailsCollectionViewItem)?.setHighlight(selected: false)
        }
        focusedIdx = collectionView.selectionIndexes.first
    }
    
    @IBAction func delete(_ sender: AnyObject) {
        let items = Set<Int> (collectionView.selectionIndexPaths.map { path in path.item})
        thumbnailsController?.deleteItems(items)
    }

    override func keyDown(with event: NSEvent) {
        if let ascii = event.characters?.first?.unicodeScalars.first?.value, ascii == NSDeleteFunctionKey {
            delete (self)
        } else {
            super.keyDown(with: event)
        }
    }
}
