//
//  ContentWhispererSettingsExtension.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 09/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

extension UserDefaults {
    private var firstRunKey: String {return "mainwindow.firstrun"}
    
    var firstRun: Bool {
        get {
            return self.bool(forKey: firstRunKey)
        }
        set {
            set (newValue, forKey: firstRunKey)
        }
    }
    func registerImageWhispererDefaults () {
        register(defaults: [
            firstRunKey: Bool (true)
            ])
        
    }

}
