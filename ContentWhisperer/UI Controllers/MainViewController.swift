//
//  ViewController.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    @IBOutlet weak var statusBarConstraint: NSLayoutConstraint!
    @IBOutlet weak var statusBarLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusBarLabel.stringValue = ""
        
        let _ = statusBarNotify.observe { message in self.statusBarLabel.stringValue = message}
    }
}

