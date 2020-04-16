//
//  BundleExtensions.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

extension Bundle {
    var displayName: String {
        var rv = object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        
        if rv == nil || rv! == "" {
            rv = object(forInfoDictionaryKey: "CFBundleName") as? String
        }
        
        return rv ?? "App"
    }
}

