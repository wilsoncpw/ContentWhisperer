//
//  MainWindowController.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, SectionControllerDelegate {
    
    @IBOutlet weak var titleLabel: NSTextField!
    
//    var appDelegate: AppDelegate!
    var mainViewController: MainViewController!
    var contentsSourceListViewController: ContentSourceListViewController!
    var thumbnailsCollectionViewController: ThumbnailsCollectionViewController!
        
    let contentProvider = ContentProvider (registeredContentTypes: [
        ImageContent.contentType,
        MovieContent.contentType
        ])
    
    var sectionController: SectionControllerFromContents? {
        didSet {
            sectionController?.delegate = self
            contentsSourceListViewController.sectionController = sectionController
        }
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        let failMsg = "MainWindowController Initialization Failure"
        
        let appDelegate: AppDelegate! = NSApp.delegate as? AppDelegate
        precondition(appDelegate != nil, failMsg)
        appDelegate.mainWindowController = self
        
        // Set modern title style
        window?.titleVisibility = .hidden
        window?.titlebarAppearsTransparent = true
        titleLabel.stringValue = Bundle.main.displayName
        
        // Set up links to the view controllers
        linkViewControllers (from: contentViewController)
        
        // Fail if there's a problem with the view controllers
        precondition (mainViewController != nil, failMsg)
        precondition (contentsSourceListViewController != nil, failMsg)
        precondition (thumbnailsCollectionViewController != nil, failMsg)
        
        UserDefaults.standard.registerImageWhispererDefaults ()
        
        if UserDefaults.standard.firstRun {
            if let frame = window?.frame {
                mainViewController.view.window?.setFrame(NSRect (x: frame.minX, y: frame.minY, width: 1024, height: 640), display: true)
            }
            UserDefaults.standard.firstRun = false
        }
    }
    
    private func linkViewControllers (from controller: NSViewController?) {
        if let controller = controller {
            switch controller {
            case let mv as MainViewController : mainViewController = mv
            case let cv as ContentSourceListViewController : contentsSourceListViewController = cv
            case let tv as ThumbnailsCollectionViewController: thumbnailsCollectionViewController = tv
            default: break
            }
            
            controller.children.forEach { child in linkViewControllers(from: child) }
        }
    }
    
    private func reset () -> Bool {
        return true
    }
    
    func openFolderAtURL (_ url: URL)->Bool {
        if !reset () {
            return false
        }
        
        guard let contents = try? Contents (contentProvider: contentProvider, folderURL: url) else { return false }

        NSDocumentController.shared.noteNewRecentDocumentURL(url)
        sectionController = SectionControllerFromContents (contents: contents)
        
//        setTitleLabelForImages(images)
        NSDocumentController.shared.noteNewRecentDocumentURL(url)
        return true
    }
    
    func selectedSectionChanged (contents: Contents, section: ContentSection?, bucket: ContentBucket?) {
        
        if let bucket = bucket {
            thumbnailsCollectionViewController.thumbnailsController = ThumbnailsControllerFromContentBucket (contents: contents, bucket: bucket)
        }
    }
}
