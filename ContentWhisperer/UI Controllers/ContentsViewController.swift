//
//  ContentsViewController.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 02/11/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa

class ContentsViewController: NSViewController {
    
    var contentsView: ContentsView?
    
    var layerController: CALayerControllerFromContentBucket? {
        didSet {
            contentsView?.setContentLayer(contentLayer: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentsView = view as? ContentsView
        NotificationCenter.default.addObserver(forName: .onSelectionChanged, object: nil, queue: nil) { notification in
            self.selectionChanged(idx: notification.object as? Int)
        }
    }
    
    func selectionChanged (idx: Int?) {
        guard let layerController = layerController, let idx = idx else {
            contentsView?.setContentLayer(contentLayer: nil)
            return
        }
        
        contentsView?.setContentLayer(contentLayer: layerController.getCALayer(idx: idx))
    }
    
}
