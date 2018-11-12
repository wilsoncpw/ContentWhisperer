//
//  ContentsViewController.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 02/11/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa

class ContentsViewController: NSViewController {
    
    @IBOutlet weak var slider: NSSlider!
    @IBOutlet weak var contentsView: ContentsView!
    
    var layerController: CALayerControllerFromContentBucket? {
        didSet {
            contentsView?.setContentLayer(contentLayer: nil)
            currentIdx = -1
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: .onSelectionChanged, object: nil, queue: nil) { notification in
            self.selectionChanged(idx: notification.object as? Int)
        }
    }
    
    var currentIdx = -1
    
    func selectionChanged (idx: Int?) {
        guard let layerController = layerController else {
            return
        }
        
        if currentIdx >= 0 {
            layerController.finished (idx: currentIdx)
        }
        
        guard let idx = idx else {
            contentsView?.setContentLayer(contentLayer: nil)
            currentIdx = -1
            return
        }
        
        currentIdx = idx
        
        contentsView?.setContentLayer(contentLayer: layerController.getCALayer(idx: idx))
        
        let duration = layerController.getDuration(idx: idx)
        
        if duration == 0 {
            slider.isHidden = true
        } else {
            slider.isHidden = false
            slider.maxValue = duration
            slider.doubleValue = 0
            
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) {timer in
                let v = layerController.getCurrentPosition (idx: idx)
                if v == 0 {
                    timer.invalidate()
                    self.slider.doubleValue = self.slider.maxValue
                } else {
                    self.slider.doubleValue = v
                }
            }
        }
    }
    
    @IBAction func sliderSlid(_ sender: Any) {
        guard let layerController = layerController else {
            return
        }
        if currentIdx == -1 {
            return
        }
        layerController.setCurrentPosition(idx: currentIdx, value: slider.doubleValue)
    }
}
