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
}
