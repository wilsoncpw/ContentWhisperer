//
//  ContentSourceListViewController.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa

class ContentSourceListViewController: NSViewController, NSOutlineViewDelegate, NSOutlineViewDataSource, SectionControllerDelegate {

    @IBOutlet weak var outlineView: NSOutlineView!
    var sectionController: SectionControllerFromContents? {
        willSet {
            sectionController?.delegate = nil
        }
        didSet {
            sectionController?.delegate = self
            outlineView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        switch item ?? sectionController ?? 0 {
        case _ as ContentSection:
            return 1
        case let controller as SectionControllerFromContents:
            return controller.sectionCount
        default:
            return 0
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return item is ContentSection
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        switch item ?? sectionController ?? 0 {
        case let section as ContentSection:
            return section.contents.count
        case let controller as SectionControllerFromContents:
            return controller.getSection (idx: index)
        default:
            return "fuck"
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        if let section = item as? ContentSection {
            if let rv = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier (rawValue: "HeaderCell" ), owner: self) as? NSTableCellView {
                rv.textField?.stringValue = section.name
                return rv
            }
        } else {
            if let rv = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier (rawValue: "DataCell"), owner: self) as? NSTableCellView {
                if let i = item as? Int {
                    rv.textField?.stringValue = String (i)
                    return rv
                }
            }
        }
        return nil
    }
    
    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        return item is ContentSection
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        return !(item is ContentSection)
    }
    
}
