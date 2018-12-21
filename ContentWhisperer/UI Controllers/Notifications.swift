//
//  Notifications.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 29/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let onSelectionChanged = Notification.Name ("selectionChanged")      // ThumbnalisViewController   -> ContentViewController
    static let onThumbnailsRemoved = Notification.Name ("thumbnailsRemoved")    //            "               -> ContentsSourceListViewController
}
