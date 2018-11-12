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
    
    var contentPlayer: ContentPlayer?
    var timer: Timer?
    
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
        self.contentPlayer!.delegate = self
        contentsView.setContentLayer(contentLayer: contentPlayer.caLayer)
        contentPlayer.play()
        
        var duration = contentPlayer.duration
        
        guard duration != 0 else {
            slider.isHidden = true
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) {timer in
                let v = contentPlayer.currentPosition
                print (contentPlayer.duration)
            }
            return
        }
        
        slider.isHidden = false
        slider.maxValue = duration
        slider.doubleValue = 0
        contentPlayer.play()
            
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {timer in
            let v = contentPlayer.currentPosition
            
            if duration != contentPlayer.duration {
                duration = contentPlayer.duration
                self.slider.maxValue = duration
            }
            self.slider.doubleValue = v
        }
    }
    
    @IBAction func sliderSlid(_ sender: Any) {
        guard let contentPlayer = contentPlayer else {
            return
        }
        
        contentPlayer.currentPosition = slider.doubleValue
    }
    
    func finished () {
//        timer?.invalidate()
//        timer = nil
    }
}
