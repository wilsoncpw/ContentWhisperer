//
//  MainWindowController.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, SectionControllerDelegate, NSMenuItemValidation {
    
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var titleLabelContainer: NSView!
    
//    var appDelegate: AppDelegate!
    var mainViewController: MainViewController!
    var contentsSourceListViewController: ContentSourceListViewController!
    var thumbnailsCollectionViewController: ThumbnailsCollectionViewController!
    var contentsViewController: ContentsViewController!
    var infoViewController: InfoViewController!
        
    let contentProvider = ContentProvider (registeredContentTypes: [
        ImageContent.contentType,
        MovieContent.contentType,
        PDFContent.contentType
        ])
    
    var sectionController: SectionControllerFromContents? {
        didSet {
            sectionController?.delegate = self
            contentsSourceListViewController.sectionController = sectionController
            thumbnailsCollectionViewController.thumbnailsController = nil
            infoViewController.thumbnailsController = nil
            contentsViewController.playerController = nil
            setTitleLabel (value: sectionController?.contents.folderURL.lastPathComponent ?? Bundle.main.displayName)
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
        setTitleLabel(value: Bundle.main.displayName)
        
        // Set up links to the view controllers
        linkViewControllers (from: contentViewController)
        
        // Fail if there's a problem with the view controllers
        precondition (mainViewController != nil, failMsg)
        precondition (contentsSourceListViewController != nil, failMsg)
        precondition (thumbnailsCollectionViewController != nil, failMsg)
        precondition (contentsViewController != nil, failMsg)
        precondition (infoViewController != nil, failMsg)

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
            case let co as ContentsViewController: contentsViewController = co
            case let iv as InfoViewController: infoViewController = iv
            default: break
            }
            
            controller.children.forEach { child in linkViewControllers(from: child) }
        }
    }
    
    private func reset () -> Bool {
        sectionController = nil
        return true
    }
    
    private func setTitleLabel (value: String) {
        titleLabel.stringValue = value
    }
    
    func openFolderAtURL (_ url: URL)->Bool {
        if !reset () { return false }
                
        statusBarNotify (message: "Loading...").post()
        let loader = ContentLoader (folderURL: url, contentProvider: contentProvider)
        loader.load { result in
            statusBarNotify (message: "").post()

            switch result {
            case .failure(let error) : Swift.print (error)
            case .success(let contents) : self.sectionController = SectionControllerFromContents (contents: contents)
            }
        }
        
        NSDocumentController.shared.noteNewRecentDocumentURL(url)
        
        return true
    }
    
    func selectedSectionChanged (sender: Any, section: ContentSection?, bucket: ContentBucket?) {
        
        guard let contents = sectionController?.contents else { return }
        
        if let bucket = bucket {
            contentsViewController.playerController = PlayerControllerFromContentBucket (contents: contents, bucket: bucket)
            let thumbnailsController = ThumbnailsControllerFromContentBucket (contents: contents, bucket: bucket)
            thumbnailsCollectionViewController.thumbnailsController = thumbnailsController
            infoViewController.thumbnailsController = thumbnailsController
            window?.makeFirstResponder(thumbnailsCollectionViewController.collectionView)
        } else {
            thumbnailsCollectionViewController.thumbnailsController = nil
            contentsViewController.playerController = nil
            infoViewController.thumbnailsController = nil
        }
    }
    
    @IBAction func printImage (_ sender: AnyObject) {
        
        guard let image = contentsViewController.contentPlayer?.takeSnaphot() else {
            return
        }
        
        let view = PrintView ()
        view.setImages(images: [image])
        view.print()
    }
    
    func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        
        guard menuItem.tag == 100 else {
            return true
        }
        
        return contentsViewController.contentPlayer != nil
    }
}
