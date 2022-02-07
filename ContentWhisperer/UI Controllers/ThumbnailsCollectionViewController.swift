//
//  ThumbnailsCollectionViewController.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 31/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa
import AVFoundation

//=============================================================================
/// Controller for the NSCollectionView used to display thumbnails
class ThumbnailsCollectionViewController: NSViewController, NSMenuItemValidation {

   
    @IBOutlet weak var collectionView: ThumbnailCollectionView!
    @IBOutlet weak var openWithMenu: NSMenu!
    @IBOutlet weak var dynamicWallpaperMenuItem: NSMenuItem!
    
    var contentCount : Int { return thumbnailsController?.contentCount ?? 0 }
    var defaultApplicationURL: URL?
    var applicationURLs: [URL]?

    //-----------------------------------------------------------------------
    /// The thumbnailsController
    ///
    /// Set by the main window controller whenever the user selects a content bucket
    var thumbnailsController: ThumbnailsController? {
        willSet {
            thumbnailsController?.delegate = nil
        }
        didSet {
            thumbnailsController?.delegate = self
            focusedIdx = nil
            collectionView.reloadData()
            setFocusedIdx (idx: contentCount > 0 ? 0 : nil)
        }
    }
    
    //-----------------------------------------------------------------------
    /// The index of the focused thumbnail.
    ///
    /// For simplicity we always treat the first selected thumbnail as the focused one
    var focusedIdx: Int? {
        didSet {
            if focusedIdx != oldValue {
                selectionChangedNotify (idx: focusedIdx ?? -1).post()
                if let idx = focusedIdx, let statusMessage = thumbnailsController?.getThumbnailPathForDisplay(idx: idx) {
                    statusBarNotify (message: statusMessage).post()
                } else {
                    statusBarNotify (message: "").post()
                }
            }
            populateThumbnailContextMenu ()
        }
    }
    
    func setFocusedIdx (idx: Int?) {
        if let f = idx {
            let item = collectionView.item(at: f) as? ThumbnailsCollectionViewItem
            item?.setHighlight(selected: true)
            collectionView.selectionIndexes = [f]
            let p = IndexPath (item: f, section: 0)
            collectionView.scrollToItems(at: [p], scrollPosition: .left)
        } else {
            collectionView.selectionIndexes = []
        }
        focusedIdx = idx
    }
    
    private func addURLToContextMenu (url: URL) {
        let s = NSString (string: url.lastPathComponent).deletingPathExtension
        
        let item = NSMenuItem (title: s, action: #selector(contextItemSelected(_:)), keyEquivalent: "")
        item.representedObject = url
        
        if let icon = NSWorkspace.shared.icon(forFile: url.path).bestRepresentation(for: NSRect (x: 0, y: 0, width: 16, height: 16), context: nil, hints: nil) {
            let img = NSImage (size: icon.size)
            img.addRepresentation(icon)
            item.image = img
        }
        openWithMenu.addItem(item)
    }
    
    private func populateThumbnailContextMenu () {
        openWithMenu.items.removeAll();

        guard let idx = focusedIdx, let url = thumbnailsController?.getThumbnailURL(idx: idx) else {
            return
        }
        
        defaultApplicationURL = NSWorkspace.shared.urlForApplication(toOpen: url)
        if let appURLs = NSWorkspace.shared.urlsForApplication(toOpen: url)?.dropFirst() {
            let urls = [URL] (appURLs)
            applicationURLs = urls.sorted { url1, url2->Bool in url1.lastPathComponent < url2.lastPathComponent }
        } else {
            applicationURLs = nil
        }
        
        if let defaultApplicationURL = defaultApplicationURL {
            addURLToContextMenu(url: defaultApplicationURL)
            
            if (applicationURLs?.count ?? 0) > 0 {
                openWithMenu.addItem(NSMenuItem.separator())
            }
        }
        
        applicationURLs?.forEach { url in addURLToContextMenu(url: url) }
    }
    
    @objc func contextItemSelected (_ sender: NSMenuItem) {
        guard let appurl = sender.representedObject as? URL, let idx = focusedIdx, let url = thumbnailsController?.getThumbnailURL(idx: idx) else {
            return
        }
//        do {
//            try NSWorkspace.shared.open([url], withApplicationAt: appurl, configuration: [:])
            NSWorkspace.shared.open([url], withApplicationAt: appurl, configuration: NSWorkspace.OpenConfiguration())
//        } catch let e {
//            print (e.localizedDescription)
//        }
        
    }
    
    private func turnPage (direction: TurnPageDirection) {
        turnPageNotify (direction: direction).post()
    }
    
    //-----------------------------------------------------------------------
    /// func delete
    ///
    /// Handler for the 'delete' action sent by the main menu or its key equivalent - which
    /// is set in IB to the '<--' delete key.
    @IBAction func delete(_ sender: AnyObject) {
        let items = Set<Int> (collectionView.selectionIndexPaths.map { path in path.item})
        thumbnailsController?.deleteItems(items)
    }
    
    //-----------------------------------------------------------------------
    /// override func keyDown
    ///
    /// In addition to the '<--' delete key above, also treat the 'forward delete' key
    /// as 'delete'.  This key is labelled 'delete' on extended keyboards
    override func keyDown(with event: NSEvent) {
        if let ascii = event.characters?.first?.unicodeScalars.first?.value {
            switch Int (ascii) {
            case NSDeleteFunctionKey: delete (self)
            case NSDownArrowFunctionKey: turnPage(direction: .next)
            case NSUpArrowFunctionKey: turnPage(direction: .prev)
            default: super.keyDown(with: event)
            }
        } else {
            super.keyDown(with: event)
        }
    }
    
    func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        if menuItem === dynamicWallpaperMenuItem {
            print ("Woo")
            return collectionView.selectionIndexPaths.count == 2
        }
        return true
    }
    
    private func loadViewFromNib (name: String) -> NSView? {
        var topLevelObjects: NSArray?
        if Bundle.main.loadNibNamed("SaveDynamicWallpaperView", owner: self, topLevelObjects: &topLevelObjects) {
            return topLevelObjects?.first(where:) { obj in obj is NSView} as? NSView
        }
        return nil
    }
    
    private func saveDynamicWallpaper (url: URL, lightImage: CGImage, darkImage: CGImage) throws {
        guard let imageDestination = CGImageDestinationCreateWithURL(url as CFURL, AVFileType.heic as CFString, 2, nil) else {
            return
        }
        
        struct Metadata: Codable {
            public let darkIdx: Int
            public let lightIdx: Int
            
            private enum CodingKeys: String, CodingKey {
                case darkIdx = "d"
                case lightIdx = "l"
            }
        }
        
        let encoder = PropertyListEncoder ()
        encoder.outputFormat = .binary
        let dynamicMetadata = Metadata (darkIdx: 1, lightIdx: 0)
        let imageMetadata = CGImageMetadataCreateMutable()
        
        guard
            let metadata = try? encoder.encode(dynamicMetadata).base64EncodedString(),
            let tag = CGImageMetadataTagCreate(
                "http://ns.apple.com/namespace/1.0/" as CFString,        // xmlns
                "apple_desktop" as CFString,                             // prefix
                "apr" as CFString,                                       // name
                .string,                                                 // type
                metadata as CFString),                                    // value
            CGImageMetadataSetTagWithPath(imageMetadata, nil, "xmp:apr" as CFString, tag) else {
            return
        }
        
        CGImageDestinationAddImageAndMetadata(imageDestination, lightImage, imageMetadata, nil)
        CGImageDestinationAddImage(imageDestination, darkImage, nil)
        
        CGImageDestinationFinalize(imageDestination)
    }
    
    @IBAction func dynamicWallpaperItemClicked(_ sender: Any) {
        
        guard collectionView.selectionIndexes.count == 2, let window = view.window, let thumbnailsController = thumbnailsController else { return }
        guard let idx1 = collectionView.selectionIndexes.first else { return }
        guard let idx2 = collectionView.selectionIndexes.last else { return }
        guard let accessoryView = loadViewFromNib(name: "SaveDynamicWallpaperView") as? SaveDynamicWallpaperView else { return }
        
        let controllerFactory = ContentControllerFactoryFromContentBucket (contents: thumbnailsController.contents, bucket: thumbnailsController.bucket)
        
        guard let cg1 = try? controllerFactory.getContentController(idx: idx1)?.takeSnaphot(), let cg2 = try? controllerFactory.getContentController(idx: idx2)?.takeSnaphot() else { return }
        
        accessoryView.viewLight.image = NSImage (cgImage: cg1, size: .zero)
        accessoryView.viewDark.image = NSImage (cgImage: cg2, size: .zero)
        
        let savePanel = NSSavePanel ()
        savePanel.accessoryView = accessoryView
        
        savePanel.beginSheetModal(for: window) {
            response in
            
            if response == .OK {
                let lightImage: CGImage
                let darkImage: CGImage
                
                if accessoryView.radioButtonLight.state == .on {
                    lightImage = cg1
                    darkImage = cg2
                } else {
                    lightImage = cg2
                    darkImage = cg1
                }
                if let url = savePanel.url {
                    do {
                        try DynamicWallpaperSaver (lightImage: lightImage, darkImage: darkImage).saveTo(url: url)
                    } catch let e {
                        print (e.localizedDescription)
                    }
                }
            }
        }
    }
}

//============================================================================
// MARK: - Data Source for thumbnails collection view
extension ThumbnailsCollectionViewController: NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentCount
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let collectionViewItem = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ThumbnailsCollectionViewItem"), for: indexPath)
        
        if let tc = thumbnailsController, let cvi = collectionViewItem as? ThumbnailsCollectionViewItem {
            cvi.setImage(controller:tc, imageIdx: indexPath.item)
        }
        
        return collectionViewItem
    }
}

// MARK: - Delegate for thumbnails controller
extension ThumbnailsCollectionViewController : ThumbnailsControllerDelegate {
    func reloadThumbnails() {
        focusedIdx = nil
        collectionView.reloadData()
        setFocusedIdx (idx: contentCount > 0 ? 0 : nil)
    }
    
    func reloadThumbnail(sender: Any, idx: Int) {
        if let i = collectionView.item(at: idx) as? ThumbnailsCollectionViewItem {
            i.displayCachedThumbnail()
        }
    }
    
    func removeThumbnails (sender: Any, idxs: Set<Int>) {
        collectionView.deleteItems(at: Set<IndexPath> (idxs.map { idx in return IndexPath (item: idx, section: 0)}))
        thumbnailsRemovedNotify ().post()
        
        guard var newFocus = focusedIdx, contentCount > 0 else {
            focusedIdx = nil
            return
        }
        
        newFocus = newFocus >= contentCount ? contentCount - 1 : newFocus
        
        if newFocus != focusedIdx {
            setFocusedIdx (idx: newFocus == -1 ? nil : newFocus)
        } else {
            setFocusedIdx (idx: newFocus == -1 ? nil : newFocus)
            selectionChangedNotify (idx: focusedIdx ?? -1).post()
        }
    }
}

// MARK: - Delegate for thumbnails collection view
extension ThumbnailsCollectionViewController: NSCollectionViewDelegate {
    
    func collectionView(_ collectionView: NSCollectionView, willDisplay item: NSCollectionViewItem, forRepresentedObjectAt indexPath: IndexPath) {
        thumbnailsController?.itemRequired(idx: indexPath.item)
    }
    
    func collectionView(_ collectionView: NSCollectionView, didEndDisplaying item: NSCollectionViewItem, forRepresentedObjectAt indexPath: IndexPath) {
        thumbnailsController?.itemNotRequired(idx: indexPath.item)
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        for path in indexPaths {
            (collectionView.item(at: path) as? ThumbnailsCollectionViewItem)?.setHighlight(selected: true)
        }
        focusedIdx = collectionView.selectionIndexes.first
    }
    
    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        indexPaths.forEach() {
            path in
            (collectionView.item(at: path) as? ThumbnailsCollectionViewItem)?.setHighlight(selected: false)
        }
        focusedIdx = collectionView.selectionIndexes.first
    }
}
