//
//  SectionControllerFromContents.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 10/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation


class SectionControllerFromContents: SectionController {
    let contents: Contents
    weak var delegate: SectionControllerDelegate?
    
    init (contents: Contents) {
        self.contents = contents
    }
    
    var sectionCount: Int {
        return contents.contentSections.count
    }
    
    func getSection (idx: Int) -> ContentSection {
        return contents.contentSections [idx]
    }
}
