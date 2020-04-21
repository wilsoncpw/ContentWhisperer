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
    
    var playerController: PlayerController? {
        didSet {
            contentsView?.setContentLayer(contentLayer: nil)
            stopTimer()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = selectionChangedNotify.observe { idx in self.selectionChanged(idx: idx) }
        let _ = turnPageNotify.observe { direction in self.turnPage (direction: direction) }
        
        pausePlayButton.isHidden = true
    }
    

    private func stopTimer () {
        timer?.invalidate()
        timer = nil
        slider.isHidden = true
        pausePlayButton.isHidden = true
    }
    
    private func selectionChanged (idx: Int?) {
        contentPlayer = nil
        stopTimer()
        
        guard let playerController = playerController, let idx = idx, let contentPlayer = playerController.getContentPlayer(idx: idx) else {
            contentsView.setContentLayer(contentLayer: nil)
            slider.isHidden = true
            return
        }
    
        self.contentPlayer = contentPlayer
        contentPlayer.delegate = self
        contentPlayer.suggestedSize = view.frame.size
        contentsView.setContentLayer(contentLayer: contentPlayer.caLayer)
    }
    
    private func turnPage (direction: TurnPageDirection) {
        
        guard let contentPlayer = contentPlayer else {
            return
        }
        
        switch direction {
        case .next: contentPlayer.nextPage()
        case .prev: contentPlayer.prevPage()
        }
        
        contentPlayer.suggestedSize = view.frame.size
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
        contentPlayer?.currentPosition = slider.doubleValue
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
