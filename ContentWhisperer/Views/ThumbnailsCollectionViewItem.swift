//
//  ThumbnailsCollectiomnViewITem.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 31/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa

class ThumbnailsCollectionViewItem: NSCollectionViewItem {
    
    @IBOutlet weak var thumbnailView: ThumbnailView!
    @IBOutlet weak var label: NSTextField!
    private var cachedThumbnail: CachedThumbnail?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer?.borderColor = NSColor.alternateSelectedControlColor.cgColor
        view.layer?.cornerRadius = 0
    }
    
    //-----------------------------------------------------------------------------------
    // Called by the view controller to set the image to display
    func setImage (controller: ThumbnailsController, imageIdx: Int?) {
        var selected = false
        if let idx = imageIdx {
            cachedThumbnail = controller.getThumbnail(idx: idx)
            if let tcv = collectionView  {
                selected = tcv.selectionIndexes.contains(idx)
            }
            label.stringValue = controller.getThumbnailLabel (idx: idx)
            displayCachedThumbnail()
        } else {
            cachedThumbnail = nil
        }
        
        setHighlight(selected: selected)
    }
    
    func displayCachedThumbnail () {
        thumbnailView.setCGImage(cgImage: cachedThumbnail?.cgImage)
    }
    
    //-----------------------------------------------------------------------------------
    func setHighlight (selected: Bool) {
        view.layer?.borderWidth = selected ? 3.0 : 0.0
    }
}
