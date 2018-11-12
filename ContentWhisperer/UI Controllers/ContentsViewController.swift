//
//  ContentsViewController.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 02/11/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Cocoa

class ContentsViewController: NSViewController, ContentPlayerDelegate {
    

    @IBOutlet weak var slider: NSSlider!
    @IBOutlet weak var contentsView: ContentsView!
    
    var contentPlayer: ContentPlayer?
    var timer: Timer?
    
    var layerController: CALayerControllerFromContentBucket? {
        didSet {
            contentsView?.setContentLayer(contentLayer: nil)
            stopTimer()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: .onSelectionChanged, object: nil, queue: nil) { notification in
            self.selectionChanged(idx: notification.object as? Int)
        }
    }
    
    private func stopTimer () {
        timer?.invalidate()
        timer = nil
    }
    
    func selectionChanged (idx: Int?) {
        contentPlayer = nil
        stopTimer()
        
        guard let layerController = layerController, let idx = idx, let contentPlayer = layerController.getContentPlayer(idx: idx) else {
            contentsView.setContentLayer(contentLayer: nil)
            slider.isHidden = true
            return
        }
    
        self.contentPlayer = contentPlayer
        contentPlayer.delegate = self
        contentsView.setContentLayer(contentLayer: contentPlayer.caLayer)
        
        if contentPlayer.duration == 0 {
            return
        }
        
        slider.maxValue = contentPlayer.duration
        slider.doubleValue = 0
        slider.isHidden = false

        contentPlayer.play()
            
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {timer in
            self.slider.doubleValue = contentPlayer.currentPosition
         }
    }
    
    func finished(sender: Any) {}
    
    @IBAction func sliderSlid(_ sender: Any) {
        guard let contentPlayer = contentPlayer else {
            return
        }
        
        contentPlayer.currentPosition = slider.doubleValue
    }
}
