//
//  ContentControllerFactory.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 13/11/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

protocol ContentControllerFactory: AnyObject {
    func getContentController (idx: Int) -> ContentController?
}

