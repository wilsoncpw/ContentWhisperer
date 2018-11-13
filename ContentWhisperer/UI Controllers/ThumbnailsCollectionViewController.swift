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
            selectedIdx = nil
            collectionView.reloadData()
        }
    }
    
    var selectedIdx: Int? {
        didSet {
            if selectedIdx != oldValue {
                NotificationCenter.default.post(name: .onSelectionChanged, object: selectedIdx)
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
        selectedIdx = collectionView.selectionIndexes.first
    }
    
    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        indexPaths.forEach() {
            path in
            (collectionView.item(at: path) as? ThumbnailsCollectionViewItem)?.setHighlight(selected: false)
        }
        selectedIdx = collectionView.selectionIndexes.first
    }
    
}
