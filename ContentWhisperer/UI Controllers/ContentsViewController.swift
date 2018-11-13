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
    @IBOutlet weak var pausePlayButton: NSButton!
    
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
        slider.isHidden = true
        pausePlayButton.isHidden = true
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
    }
    
    func statusChanged(sender: Any, status: ContentPlayerStatus) {
        if status == .readyToPlay {
            guard let contentPlayer = contentPlayer else { return }
            
            slider.maxValue = contentPlayer.duration
            slider.doubleValue = 0
            slider.isHidden = false
            pausePlayButton.isHidden = false
            
            contentPlayer.play()
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {timer in
                self.slider.doubleValue = contentPlayer.currentPosition
            }
        }
    }
    
    
    @IBAction func sliderSlid(_ sender: Any) {
        guard let contentPlayer = contentPlayer else { return }
        
        contentPlayer.currentPosition = slider.doubleValue
    }
    
    @IBAction func pausePlayClicked(_ sender: Any) {
        guard let contentPlayer = contentPlayer else { return }
        
        if contentPlayer.isPlaying {
            contentPlayer.stop()
        } else {
            contentPlayer.play()
        }
    }
}
