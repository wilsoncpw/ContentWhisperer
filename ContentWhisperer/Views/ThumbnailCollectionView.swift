//
//  ThumbnailCollectionView.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 19/12/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa

class ThumbnailCollectionView: NSCollectionView {
    
    let scrollerWidth = NSScroller.scrollerWidth(for: .regular, scrollerStyle: .overlay)
    
    //----------------------------------------------------------------------------
    /// NSCollectionView doesn't handle the delete and backspace keys how we want.  So pass these up the
    /// responder chain to the TumbnailsCollectionViewController - we handle them there.
    ///
    /// - Parameter event: The keydown event
    override func keyDown(with event: NSEvent) {
        if let ascii = event.characters?.first?.unicodeScalars.first?.value, ascii == NSDeleteCharacter || ascii == NSDeleteFunctionKey || ascii == NSUpArrowFunctionKey || ascii == NSDownArrowFunctionKey {
            nextResponder?.keyDown(with: event)
        } else {
            super.keyDown(with: event)
        }
    }
    
    //----------------------------------------------------------------------------
    /// Override layout to dynamically resize the thumbnails
    override func layout() {
        super.layout()
        
        if let layout = collectionViewLayout as? NSCollectionViewFlowLayout {
            let adjustedHeight = frame.height-scrollerWidth
            
            layout.itemSize.width = adjustedHeight
            layout.itemSize.height = adjustedHeight
        }
    }
    
    //----------------------------------------------------------------------------
    /// Override viewDidEndLiveResize to make sure the currently selected item is still visible after a resize.
    ///
    /// It looks a bit shit if you do this dynamically in 'layout'
    override func viewDidEndLiveResize() {
        let sel = selectionIndexes.min()
        if let sel = sel {
            let p = IndexPath (item: sel, section: 0)

            scrollToItems(at: [p], scrollPosition: .centeredHorizontally)
        }
    }
}
