//
//  SaveDynamicWallpaperView.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 01/02/2021.
//  Copyright © 2021 Colin Wilson. All rights reserved.
//

import Cocoa

class SaveDynamicWallpaperView: NSView {

    @IBOutlet weak var viewLight: NSImageView!
    @IBOutlet weak var viewDark: NSImageView!
    
    @IBOutlet weak var radioButtonLight: NSButton!
    @IBOutlet weak var radioButtonDark: NSButton!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    @IBAction func lightImageRadioButtonClicked(_ sender: Any) {
    }
}
