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
    @IBOutlet weak var pausePlayButton: NSButton!
    
    var contentController: ContentController? {
        didSet {
            stopTimer()
            slider.isHidden = true
            contentController?.suggestedSize = view.frame.size
            contentsView.setContentLayer(contentLayer: contentController?.caLayer)
        }
    }
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = turnPageNotify.observe { direction in self.turnPage (direction: direction) }
        let _ = contentStatusChangedNotify.observe { status in self.statusChanged(status: status)}
        
        pausePlayButton.isHidden = true
    }
    

    private func stopTimer () {
        timer?.invalidate()
        timer = nil
        slider.isHidden = true
        pausePlayButton.isHidden = true
    }
    
    private func turnPage (direction: TurnPageDirection) {
        
        guard let contentController = contentController, let pagination = contentController as? ContentPagination else {
            return
        }
        
        switch direction {
        case .next: pagination.nextPage()
        case .prev: pagination.prevPage()
        }
        
        contentController.suggestedSize = view.frame.size
        contentsView.setContentLayer(contentLayer: contentController.caLayer)
    }
    
    private func statusChanged(status: ContentPlayerStatus) {
        if status == .readyToPlay {
            guard let contentPlayer = contentController as? ContentPlayer else { return }
            
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
        guard let contentPlayer = contentController as? ContentPlayer else { return }
        contentPlayer.currentPosition = slider.doubleValue
    }
    
    @IBAction func pausePlayClicked(_ sender: Any) {
        guard let contentPlayer = contentController as? ContentPlayer else { return }
        
        if contentPlayer.isPlaying {
            contentPlayer.stop()
        } else {
            contentPlayer.play()
        }
    }
    
 
}
