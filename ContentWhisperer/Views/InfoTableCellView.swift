//
//  InfoTableCellView.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 03/06/2020.
//  Copyright © 2020 Colin Wilson. All rights reserved.
//

import Cocoa

class InfoTableCellView: NSTableCellView {
    @IBOutlet weak var labelTestField: NSTextField!
    @IBOutlet weak var shuffleButton: NSButton!
    
    var thumbnailsController: ThumbnailsController? {
        didSet {
            if let value = thumbnailsController {
                labelTestField.stringValue = "\(value.contentCount) items"
                shuffleButton.state = value.shuffled ? .on : .off
            }
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    @IBAction func shuffleButtonClicked(_ sender: Any) {
        if shuffleButton.state == .on {
            thumbnailsController?.shuffleContents()
        } else {
            thumbnailsController?.sortContents()
        }
    }
}
