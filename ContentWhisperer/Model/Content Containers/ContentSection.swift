//
//  ContentSection.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 10/10/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation


typealias BucketDictionary = Dictionary<String, ContentBucket>


//=================================================================================
/// A content section contains a dictionary of buckets - each one containing content
class ContentSection {
    let name: String;
    private (set) var buckets: [ContentBucket]

    //----------------------------------------------------------------------------
    /// init
    ///
    /// - Parameters:
    ///   - name: The section name = eg. Images, Videos
    ///   - contents: Array of objects confirming to Content
    init (name: String, contents: [Content]) {
        self.name = name
        
        let definitions = type (of: contents [0]).contentType.bucketDefinitions
        
        let bucketMap = contents.reduce (into: BucketDictionary ()) {bucketsSum, content in
            if let newBucket = ContentSection.AddContentToBuckets (bucketMap: bucketsSum, content: content, definitions: definitions) {
                bucketsSum [newBucket.name] = newBucket
            }
        }
        
        self.buckets = definitions.reduce(into: [ContentBucket] ()) {
            accum, definition in
            
            if let bucket = bucketMap [definition.name] {
                bucket.sortContents()
                accum.append(bucket)
            }
        }
    }
    
    //----------------------------------------------------------------------------
    /// AddContentToBuckes
    ///
    /// - Parameters:
    ///   - bucketMap: The dictionary of existing buckets
    ///   - content: The content to add
    /// - Returns: A new bucket containing the content - if the content won't fit in an existing one.
    private static func AddContentToBuckets (bucketMap: BucketDictionary, content: Content, definitions: [BucketDefinition]) -> ContentBucket? {
        guard let bucketName = definitions.first(where:) ({name, filetypes in
            let ext = (content.fileName as NSString).pathExtension.lowercased()
            return filetypes.contains(ext)
        })?.name else {
            return nil
        }
    
        guard let bucket = bucketMap [bucketName] else {
            let newBucket = ContentBucket (name: bucketName)
            newBucket.addContent (content)
            return newBucket
        }
        bucket.addContent (content)
        return nil
    }
    
    
    func removeContent (_ content: [Content]) -> [Content] {
        var emptyBuckets = [Int] ()
        defer {
            emptyBuckets.reversed().forEach { bucketIdx in buckets.remove(at: bucketIdx) }
        }
        var idx = 0
        return buckets.reduce(into: [Content] ()) {accum, bucket in
            accum.append(contentsOf: bucket.removeContent(content))
            if bucket.contents.count == 0 {
                emptyBuckets.append(idx)
            }
            idx += 1
        }
    }
}
