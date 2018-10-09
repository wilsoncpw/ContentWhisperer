//
//  ContentSourceListViewController.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa

class ContentSourceListViewController: NSViewController, NSOutlineViewDelegate, NSOutlineViewDataSource {

    @IBOutlet weak var outlineView: NSOutlineView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadData()
    }
    
    private func reloadData () {
        outlineView.reloadData()
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if item == nil {
            return 5
        } else {
            return 0
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        return "Hello"
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        if let rv = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier (rawValue: "HeaderCell" ), owner: self) as? NSTableCellView {
            rv.textField?.stringValue = item as? String ?? "grr"
            return rv
        }
        return nil
    }
}
