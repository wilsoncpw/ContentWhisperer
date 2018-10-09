//
//  AppDelegate.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var mainWindowController: MainWindowController!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        mainWindowController = NSApplication.shared.mainWindow?.windowController as? MainWindowController
        
        assert (mainWindowController != nil, "Init failure")
    }

    //----------------------------------------------------------------------
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    //----------------------------------------------------------------------
    func application(_ sender: NSApplication, openFile filename: String) -> Bool {
        return openFolderAtURL(URL (fileURLWithPath: filename))
    }
    
    //----------------------------------------------------------------------
    @IBAction func openDocument (_ sender: AnyObject) {
        let openPanel = NSOpenPanel ()
        
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        openPanel.allowsMultipleSelection = false
        openPanel.resolvesAliases = true
        
        if openPanel.runModal()  == .OK {
            if let url = openPanel.url {
                let _ = openFolderAtURL(url)
            }
        }
    }
    
    //----------------------------------------------------------------------
    func openFolderAtURL (_ url: URL)-> Bool {
        return mainWindowController?.openFolderAtURL(url) ?? false
    }

}

