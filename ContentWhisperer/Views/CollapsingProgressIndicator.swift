//
//  CollapsingProgressBar.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/11/2019.
//  Copyright © 2019 Colin Wilson. All rights reserved.
//

import Cocoa

class CollapsingProgressIndicator: NSProgressIndicator {
    override var isHidden: Bool {
        get {
            return super.isHidden
        }
        set {
            super.isHidden = newValue
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: NSSize {
        get {
            if isHidden {
                return NSSize (width: NSView.noIntrinsicMetric, height: 0)
            } else {
                return super.intrinsicContentSize
            }
        }
    }
}

class CollapsingButton: NSButton {
    override var isHidden: Bool {
        get {
            return super.isHidden
        }
        set {
            super.isHidden = newValue
            invalidateIntrinsicContentSize()

        }
    }
    
    override var intrinsicContentSize: NSSize {
        get {
            if isHidden {
                return NSSize (width: NSView.noIntrinsicMetric, height: 0)
            } else {
                return super.intrinsicContentSize
            }
        }
    }
}

class CollapsingSLider: NSSlider {
    override var isHidden: Bool {
        get {
            return super.isHidden
        }
        set {
            super.isHidden = newValue
            invalidateIntrinsicContentSize()

        }
    }
    
    override var intrinsicContentSize: NSSize {
        get {
            if isHidden {
                return NSSize (width: NSView.noIntrinsicMetric, height: 0)
            } else {
                return super.intrinsicContentSize
            }
        }
    }
}
