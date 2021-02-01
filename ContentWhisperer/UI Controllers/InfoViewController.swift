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
    
    var contentController: ContentController? {
        didSet {
            interestingMetadata = nil
            outlineView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var interestingMetadata : [(String,String)]?
    
    private func getInterestingMetadata () -> [(String,String)]? {
        
        if interestingMetadata != nil { return interestingMetadata}
        guard let imageContentPlayer = contentController as? ImageContentController else {
            return interestingMetadata
        }
        
        interestingMetadata = [(String,String)] ()
        if let cgMeta = imageContentPlayer.primaryImageMetadata {
            CGImageMetadataEnumerateTagsUsingBlock(cgMeta, nil, nil) { nm, val in
                
                let name = String (nm)
                self.interestingMetadata?.append((name,"foo"))
                
                return true
            }
        }
        
        return interestingMetadata
    }
}

extension InfoViewController: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if item == nil {
            let meta = getInterestingMetadata()
            return thumbnailsController == nil ? 0 : 1 + (meta?.count ?? 0)
        }
        return 0
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        
        guard item == nil else {
            return 0
        }
        
        if index == 0 {
            if let thumbnailsController = thumbnailsController {
                return thumbnailsController
            }
            return 0
        }
        
        if let meta = getInterestingMetadata() {
            return meta [index-1]
        }
        
        return 0
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        
        switch item {
        case let thumbnailsController as ThumbnailsController:
            let id = NSUserInterfaceItemIdentifier (rawValue: "InfoCell")
            let rv = outlineView.makeView(withIdentifier: id, owner: self) as? InfoTableCellView
            rv?.thumbnailsController = thumbnailsController
            return rv
        case let metaItem as (String,String):
            let id = NSUserInterfaceItemIdentifier (rawValue: "metaCell")
            let rv = outlineView.makeView(withIdentifier: id, owner: self) as? MetaTableCellView
            rv?.label.stringValue = metaItem.0
            return rv
        default:
            return nil
        }        
    }
}

extension InfoViewController: NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        
        let hasMetadata = getInterestingMetadata() != nil
        switch item {
        case _ as ThumbnailsController:
            return hasMetadata ? 100 : outlineView.frame.height
        case _ as (String, String):
            return 24
        default: return outlineView.frame.height
        }
    }
}
