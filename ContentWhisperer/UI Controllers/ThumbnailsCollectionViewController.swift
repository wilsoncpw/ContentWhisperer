//
//  ThumbnailsCollectionViewController.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 31/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa

//=============================================================================
/// Controller for the NSCollectionView used to display thumbnails
class ThumbnailsCollectionViewController: NSViewController {
   
    @IBOutlet weak var collectionView: NSCollectionView!
    
    var contentCount : Int { return thumbnailsController?.contentCount ?? 0 }

    //-----------------------------------------------------------------------
    /// The thumbnailsController
    ///
    /// Set by the main window controller whenever the user selects a content bucket
    var thumbnailsController: ThumbnailsController? {
        willSet {
            thumbnailsController?.delegate = nil
        }
        didSet {
            thumbnailsController?.delegate = self
            focusedIdx = nil
            collectionView.reloadData()
            setFocusedIdx (idx: contentCount > 0 ? 0 : nil)
        }
    }
    
    //-----------------------------------------------------------------------
    /// The index of the focused thumbnail.
    ///
    /// For simplicity we always treat the first selected thumbnail as the focused one
    var focusedIdx: Int? {
        didSet {
            if focusedIdx != oldValue {
                NotificationCenter.default.post(name: .onSelectionChanged, object: focusedIdx)
            }
        }
    }
    
    func setFocusedIdx (idx: Int?) {
        if let f = idx {
            collectionView.selectionIndexes = [f]
            let item = collectionView.item(at: f) as? ThumbnailsCollectionViewItem
            item?.setHighlight(selected: true)
            collectionView.becomeFirstResponder()
        } else {
            collectionView.selectionIndexes = []
        }
        focusedIdx = idx
    }
    
    //-----------------------------------------------------------------------
    /// func delete
    ///
    /// Handler for the 'delete' action sent by the main menu or its key equivalent - which
    /// is set in IB to the '<--' delete key.
    @IBAction func delete(_ sender: AnyObject) {
        let items = Set<Int> (collectionView.selectionIndexPaths.map { path in path.item})
        thumbnailsController?.deleteItems(items)
    }
    
    //-----------------------------------------------------------------------
    /// override func keyDown
    ///
    /// In addition to the '<--' delete key above, also treat the 'forward delete' key
    /// as 'delete'.  This key is labelled 'delete' on extended keyboards
    override func keyDown(with event: NSEvent) {
        if let ascii = event.characters?.first?.unicodeScalars.first?.value, ascii == NSDeleteFunctionKey {
            delete (self)
        } else {
            super.keyDown(with: event)
        }
    }
}

//============================================================================
// MARK: - Data Source for thumbnails collection view
extension ThumbnailsCollectionViewController: NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentCount
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let collectionViewItem = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ThumbnailsCollectionViewItem"), for: indexPath)
        
        if let tc = thumbnailsController, let cvi = collectionViewItem as? ThumbnailsCollectionViewItem {
            cvi.setImage(controller:tc, imageIdx: indexPath.item)
        }
        
        return collectionViewItem
    }
}

// MARK: - Delegate for thumbnails controller
extension ThumbnailsCollectionViewController : ThumbnailsControllerDelegate {
    func reloadThumbnail(sender: Any, idx: Int) {
        if let i = collectionView.item(at: idx) as? ThumbnailsCollectionViewItem {
            i.displayCachedThumbnail()
        }
    }
    
    func removeThumbnails (sender: Any, idxs: Set<Int>) {
        collectionView.deleteItems(at: Set<IndexPath> (idxs.map { idx in return IndexPath (item: idx, section: 0)}))
        NotificationCenter.default.post(name: .onThumbnailsRemoved, object: nil)
        
        guard var newFocus = focusedIdx, contentCount > 0 else {
            focusedIdx = nil
            return
        }
        
        newFocus = newFocus >= contentCount ? contentCount - 1 : newFocus
        
        if newFocus != focusedIdx {
            setFocusedIdx (idx: newFocus == -1 ? nil : newFocus)
        } else {
            setFocusedIdx (idx: newFocus == -1 ? nil : newFocus)
            NotificationCenter.default.post(name: .onSelectionChanged, object: focusedIdx)
        }
    }
}

// MARK: - Delegate for thumbnails collection view
extension ThumbnailsCollectionViewController: NSCollectionViewDelegate {
    
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
}
