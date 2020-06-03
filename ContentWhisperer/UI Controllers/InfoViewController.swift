//
//  InfoViewController.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 02/06/2020.
//  Copyright © 2020 Colin Wilson. All rights reserved.
//

import Cocoa

class InfoViewController: NSViewController {
    
    @IBOutlet weak var outlineView: NSOutlineView!
    
    var thumbnailsController: ThumbnailsController? {
        didSet {
            if let value = thumbnailsController {
                
//                detailsLabel.stringValue = "\(value.contentCount) items"
//                shuffleButton.isHidden = false
//                shuffleButton.state = .off
                
            } else {
//                detailsLabel.stringValue = ""
//                shuffleButton.isHidden = true
            }
            
            outlineView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func shufleButtonClicked(_ sender: Any) {
//        if shuffleButton.state == .on {
//            thumbnailsController?.shuffleContents()
//        } else {
//            thumbnailsController?.sortContents()
//        }
    }
    
}

extension InfoViewController: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if item == nil {
            return thumbnailsController == nil ? 0 : 1
        }
        return 0
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if item == nil, let thumbnailsController = thumbnailsController {
            return thumbnailsController
        }
        return "fuck"
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        guard let thumbailsController = item as? ThumbnailsController else {
            return nil
        }
        
        if let rv = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier (rawValue: "InfoCell" ), owner: self) as? InfoTableCellView {
            rv.thumbnailsController = thumbailsController
            return rv
        }
        
        return nil
    }
}

extension InfoViewController: NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        return outlineView.frame.height
    }
    
}
