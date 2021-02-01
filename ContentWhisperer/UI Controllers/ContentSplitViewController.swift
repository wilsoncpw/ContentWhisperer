//
//  ContentSplitViewController.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 30/01/2021.
//  Copyright © 2021 Colin Wilson. All rights reserved.
//

import Cocoa

class ContentSplitViewController: NSViewController, NSSplitViewDelegate {

    @IBOutlet weak var splitView: NSSplitView!
    
    var isHeic = false
    var contentController: ContentController? {
        didSet {
            if let imageContentController = contentController as? ImageContentController {
                showHeicSection(show: imageContentController.isHeic)
            } else {
                showHeicSection(show: false)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func showHeicSection (show: Bool) {
        isHeic = show
        let heicView = splitView.subviews[0] as NSView
        heicView.isHidden = !show
         
        splitView.display()
    }
    
    func splitView(_ splitView: NSSplitView, shouldHideDividerAt dividerIndex: Int) -> Bool {
        return !isHeic
    }
    
}
