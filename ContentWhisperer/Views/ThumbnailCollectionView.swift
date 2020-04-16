//
//  ThumbnailCollectionView.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 19/12/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa

class ThumbnailCollectionView: NSCollectionView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func keyDown(with event: NSEvent) {
        if let ascii = event.characters?.first?.unicodeScalars.first?.value, ascii == NSDeleteCharacter || ascii == NSDeleteFunctionKey {
            nextResponder?.keyDown(with: event)
        } else {
            super.keyDown(with: event)
        }
    }
    
    override func layout() {
        super.layout()
        
        if let layout = collectionViewLayout as? NSCollectionViewFlowLayout {
            let height = frame.height
            
            
            let adjustedHeight = height-26
            
            layout.itemSize.width = adjustedHeight
            layout.itemSize.height = adjustedHeight
            
            
        }
    }
    
    override func viewDidEndLiveResize() {
        let sel = selectionIndexes.min()
        if let sel = sel {
            let p = IndexPath (item: sel, section: 0)

            scrollToItems(at: [p], scrollPosition: .centeredHorizontally)
        }
    }
}
