//
//  SectionControllerFromContents.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 10/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

protocol SectionControllerDelegate: NSObjectProtocol {
    
}

class SectionControllerFromContents {
    private let contents: Contents
    weak var delegate: SectionControllerDelegate?
    
    init (contents: Contents) {
        self.contents = contents
    }
    
    var sectionCount: Int {
        return contents.sectionCount
    }
    
    func getSection (idx: Int) -> Section {
        return contents.getSection(idx:idx)
    }
}
