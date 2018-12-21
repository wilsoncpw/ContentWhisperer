//
//  OrderedDictionary.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 31/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation

public struct OrderedDictionary <Key, Value>: Collection where Key: Hashable, Key: Comparable {
    public typealias Index = Int
    public typealias Element = (key: Key, value: Value)
    
    private var keys = [Key] ()
    private var dict = [Key:Value] ()
    
    public subscript (key: Key) -> Value? {
        get {
            return dict [key]
        }
        set {
            if !dict.keys.contains(key) {
                keys.append(key)
            }
            dict [key] = newValue
        }
    }
    
    public var startIndex: Index {
        return 0
    }
    
    public var endIndex: Index {
        return keys.count
    }
    
    public var count: Int {
        return keys.count
    }
    
    public func index(after i: Int) -> Int {
        return i+1
    }
    
    public subscript(position: Int) -> (key: Key, value: Value) {
        get {
            let key = keys [position]
            return (key: key, value: dict [key]!)
        }
        set {
            if position < keys.count {
                let key = newValue.key
                let oldKey = keys [position]
                keys [position] = key
                if oldKey != key {
                    dict.removeValue(forKey: oldKey)
                }
                dict [key] = newValue.value
            }
        }
    }
}

extension OrderedDictionary: MutableCollection {
    mutating func removeValue(forKey key: Key) -> Value? {
        guard let rv = dict.removeValue(forKey: key) else {
            return nil
        }
        
        if let idx = keys.firstIndex(of: key) {
            keys.remove(at: idx)
        }
        
        return rv
    }
}

