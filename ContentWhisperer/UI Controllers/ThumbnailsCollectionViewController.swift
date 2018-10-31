//
//  ThumbnailsCollectionViewController.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 31/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa

class ThumbnailsCollectionViewController: NSViewController, NSCollectionViewDelegate, NSCollectionViewDataSource {
    
    @IBOutlet weak var collectionView: NSCollectionView!
    
    var thumbnailsController: ThumbnailsController? {
        willSet {
            
        }
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbnailsController?.contentCount ?? 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let collectionViewItem = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ThumbnailsCollectionViewItem"), for: indexPath)
        
        return collectionViewItem
    }
}
