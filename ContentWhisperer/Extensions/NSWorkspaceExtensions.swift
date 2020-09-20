//
//  NSWorkspaceExtensions.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 20/09/2020.
//  Copyright © 2020 Colin Wilson. All rights reserved.
//

import Cocoa

extension NSWorkspace {
    func urlsForApplication(toOpen: URL) -> [URL]? {
        if let arr = LSCopyApplicationURLsForURL(toOpen as CFURL, .all) {
        
            return (arr.takeRetainedValue() as! [URL])
        }
        return nil
    }
}
