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
    var sectionController: SectionController? {
        didSet {
            outlineView.reloadData()
            outlineView.expandItem(nil, expandChildren: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: .onThumbnailsRemoved, object: nil, queue: nil) {
            notification in
            self.outlineView!.reloadData()
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        switch item ?? sectionController ?? 0 {
        case let section as ContentSection:
            return section.buckets.count
        case let controller as SectionController:
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
            return section.buckets [index]
        case let controller as SectionController:
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
                } else if let b = item as? ContentBucket {
                    rv.textField?.stringValue = b.name
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
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        guard let sectionController = sectionController else {
            return
        }
        let item = outlineView.item(atRow: outlineView.selectedRow)
        switch item ?? 0 {
        case let section as ContentSection:
            sectionController.delegate?.selectedSectionChanged(contents: sectionController.contents, section: section, bucket: nil)
        case let bucket as ContentBucket:
            sectionController.delegate?.selectedSectionChanged(contents: sectionController.contents, section: nil, bucket: bucket)
        default: break
        }
    }
}
