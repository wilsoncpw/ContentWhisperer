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
            outlineView.reloadData()
        }
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
        return 0
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        
        guard
            let thumbailsController = item as? ThumbnailsController,
            case let id = NSUserInterfaceItemIdentifier (rawValue: "InfoCell"),
            let rv = outlineView.makeView(withIdentifier: id, owner: self) as? InfoTableCellView
        else {
            return nil
        }
        
        rv.thumbnailsController = thumbailsController
        return rv
    }
}

extension InfoViewController: NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        return outlineView.frame.height
    }
}
