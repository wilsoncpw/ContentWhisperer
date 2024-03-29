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
    typealias T = Int
    let payload: T
    init (idx: Int) {
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

private struct loadingNotify: Notifiable {
    static let name = Notification.Name ("loading")
    typealias T = Bool
    let payload: T
    
    init (isBusy: Bool) {
        payload = isBusy
    }
}

struct statusBarNotify: Notifiable {
    static let name = Notification.Name ("setStatusBar")
    typealias T = String
    let payload: T
    init (message: String) {
        payload = message
    }
}

enum TurnPageDirection {
    case prev
    case next
}

struct turnPageNotify: Notifiable {
    static let name = Notification.Name ("turnPage")
    typealias T = TurnPageDirection
    let payload: T
    init (direction: TurnPageDirection) {
        payload = direction
    }
}

struct contentStatusChangedNotify: Notifiable {
    static let name = Notification.Name ("contentStatusChanged")
    typealias  T = ContentPlayerStatus
    let payload: T
    init (status: ContentPlayerStatus) {
        payload = status
    }
}
