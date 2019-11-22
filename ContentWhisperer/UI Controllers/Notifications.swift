//
//  Notifications.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 29/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation


protocol Notifiable {
    static var name: Notification.Name { get }
    associatedtype T
    var payload: T { get }
}

extension Notifiable {
    func post () {
        NotificationCenter.default.post(name: Self.name, object: payload)
    }
    
    static func observe (callback: @escaping (T) -> Void) -> AnyObject{
        return NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil) { notification in
            if let payload = notification.object as? T {
                callback (payload)
            }
        }
    }
    
    static func stopObserving (obj: AnyObject?) {
        if let obj = obj {
            NotificationCenter.default.removeObserver(obj)
        }
    }
}

struct selectionChangedNotify: Notifiable {
    static let name = Notification.Name ("selectionChanged")
    typealias T = Int?
    let payload: T
    init (idx: T) {
        payload = idx
    }
}

struct thumbnailsRemovedNotify: Notifiable {
    static let name = Notification.Name ("thumbnailsRemoved")
    typealias T = Void
    let payload: T
    
    init () {
    }
}

struct loadingNotify: Notifiable {
    static let name = Notification.Name ("loading")
    typealias T = Bool
    let payload: T
    
    init (playable: Bool) {
        payload = playable
    }
}

struct statusBarNotify: Notifiable {
    static let name = Notification.Name ("setStatusBar")
    typealias T = String
    let payload: T
    init (message: T) {
        payload = message
    }
}
