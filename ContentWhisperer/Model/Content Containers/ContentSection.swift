//
//  ContentSection.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 10/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation


typealias BucketDictionary = OrderedDictionary<String, ContentBucket>

class ContentSection {
    let name: String;
    private (set) var bucketMap: BucketDictionary

    init (name: String, contents: [Content]) {
        self.name = name
        
        self.bucketMap = contents.reduce (into: BucketDictionary ()) {bucketsSum, content in
            if let newBucket = ContentSection.AddContentToBuckets (bucketMap: bucketsSum, content: content) {
                bucketsSum [newBucket.name] = newBucket
            }
        }
        
        for bucket in bucketMap {
            bucket.value.calcFileNameMap ()
        }
    }
    
    private static func AddContentToBuckets (bucketMap: BucketDictionary, content: Content) -> ContentBucket? {
        let bucketName = type (of: content).contentType.bucketDefinitions.first(where:) {name, filetypes in
            let ext = (content.fileName as NSString).pathExtension.lowercased()
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
