//
//  SectionController.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 13/11/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

protocol SectionControllerDelegate: NSObjectProtocol {
    func selectedSectionChanged (contents: Contents, section: ContentSection?, bucket: ContentBucket?)
}

protocol SectionController: AnyObject {
    var contents: Contents { get }
    var delegate: SectionControllerDelegate? { get }
    var sectionCount: Int { get }
    func getSection (idx: Int) -> ContentSection
}

