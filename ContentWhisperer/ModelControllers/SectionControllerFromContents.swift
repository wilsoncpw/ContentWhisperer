//
//  SectionControllerFromContents.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 10/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

protocol SectionControllerDelegate: NSObjectProtocol {
    func selectedSectionChanged (contents: Contents, section: ContentSection?, bucket: ContentBucket?)
}

protocol SectionController {
    var contents: Contents { get }
    var delegate: SectionControllerDelegate? { get }
    var sectionCount: Int { get }
    func getSection (idx: Int) -> ContentSection
}

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
