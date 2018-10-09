//
//  MainWindowController.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    @IBOutlet weak var titleLabel: NSTextField!
    
    var appDelegate: AppDelegate!
    var mainViewController: MainViewController!

    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Set modern title style
        window?.titleVisibility = .hidden
        
        // Set up links to the view controllers
        linkViewControllers (from: contentViewController)
        
        appDelegate = NSApplication.shared.delegate as? AppDelegate

        // Fail if there's a problem with the view controllers
        let failMsg = "MainWindowController Initialization Failure"
        assert (mainViewController != nil, failMsg)
        assert (appDelegate != nil, failMsg)
        
        UserDefaults.standard.registerImageWhispererDefaults ()
        
        if UserDefaults.standard.firstRun {
            if let frame = window?.frame {
                mainViewController.view.window?.setFrame(NSRect (x: frame.minX, y: frame.minY, width: 1024, height: 640), display: true)
            }
            UserDefaults.standard.firstRun = false
        }
        
        window?.titlebarAppearsTransparent = true
        titleLabel.stringValue = Bundle.main.displayName
    }
    
    private func linkViewControllers (from controller: NSViewController?) {
        if let controller = controller {
            switch controller {
            case let mv as MainViewController :
                mainViewController = mv
            default: break
            }
            
            for child in controller.children {
                linkViewControllers(from: child)
            }
        }
    }
    
    private func reset () -> Bool {
        return true
    }
    
    func openFolderAtURL (_ url: URL)->Bool {
        if !reset () {
            return false
        }
        
       
        // Load the images.  Note that this just initialises their file names - it doesn't
        // open the file to create the image representation - that's done when the image or
        // thumbnail controller creates a CachedThumnbnail or ImageViewImage when required.
        guard let contents = try? Contents (folderURL: url) else { return false }
        
        
//        setTitleLabelForImages(images)
        NSDocumentController.shared.noteNewRecentDocumentURL(url)
        return true
    }
    
}
