//
//  ContentSection.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 10/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation
import CWCollections

class ContentBucket : KeyProvider {
    typealias T = String
    
    var key: T {
        return name
    }
    
    let name: String
    private (set) var contents : [Content]
    
    init (name: String, initialContent: [Content]) {
        self.name = name
        self.contents = initialContent
    }
    
    func addContent (_ content: Content) {
        contents.append(content)
    }
}

typealias BucketDictionary = OrderedDictionary<ContentBucket>

extension OrderedDictionary where Value:ContentBucket {
    static func + (v1: OrderedDictionary<Value>, v2: Value?) -> OrderedDictionary<Value> {
        guard let v2 = v2 else {
            return v1
        }
        var rv = OrderedDictionary<Value>()
        
        for i in 0..<v1.count {
            let vx = v1 [i]
            rv [vx.key] = vx
        }
        rv [v2.key] = v2
    
        return rv
    }
}

class ContentSection {
    let name: String;
    private (set) var bucketMap: BucketDictionary

    init (name: String, contents: [Content]) {
        self.name = name
        
        self.bucketMap = contents.reduce (BucketDictionary ()) {bucketsSum, content in
            return bucketsSum + ContentSection.AddContentToBuckets(bucketMap: bucketsSum, content: content)
        }
    }
    
    private static func AddContentToBuckets (bucketMap: BucketDictionary, content: Content) -> ContentBucket? {
        let bucketName = type (of: content).contentType.bucketDefinitions.first(where:) {name, filetypes in
            let ext = (content.fileName as NSString).pathExtension
            return filetypes.contains(ext)
        }?.name ?? "~"
    
        guard let bucket = bucketMap [bucketName] else {
            let newBucket = ContentBucket (name: bucketName, initialContent: [content])
            return newBucket
        }
        bucket.addContent(content)
        return nil
    }
    
    func addContent (_ content: Content) {
        if let newBucket = ContentSection.AddContentToBuckets(bucketMap: bucketMap, content: content) {
            bucketMap [newBucket.name] = newBucket
        }
    }
}
