//
//  ContentBucket.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 01/11/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation


//=================================================================================
/// A content bucket contains an array of Contents of the same kind
class ContentBucket {
    let name: String
    private (set) var contents = [Content] ()
    private var _filenameMap : [String:Int]?
    private let contentQueue = DispatchQueue(label: "ContentQueue")

    //----------------------------------------------------------------------------
    /// init
    ///
    /// - Parameters:
    ///   - name: The bucket name, eg. Photos
    init (name: String) {
        self.name = name
    }
    
    //----------------------------------------------------------------------------
    /// addContent
    ///
    /// - Parameter content: The content to add
    func addContent (_ content: Content) {
        contents.append(content)
        
        contentQueue.async {
            if self._filenameMap != nil {
                self._filenameMap! [content.fileName] = self.contents.count-1
            }
        }
    }
    
    func sortContents () {
        contentQueue.async {
            self.contents.sort(by: ) { content1, content2 in
                return content1.fileName <= content2.fileName
            }
            
            self._filenameMap = nil
        }
    }
    
    //----------------------------------------------------------------------------
    /// filenameMap : Keep a dictionary of filenames and their array index that
    ///               getIndexForFilename can use.  Recalculate it if required
    private var filenameMap: [String: Int] {
        if _filenameMap == nil {
            var c = 0
            _filenameMap = contents.reduce(into: [String:Int]()) {accum, content in
                accum [content.fileName] = c
                c += 1
            }
        }
        return _filenameMap!
    }
    
    //----------------------------------------------------------------------------
    /// getIndexForFilename
    ///
    /// - Parameter fileName: The file name
    /// - Returns: The index of the contents array
    func getIndexForFilename (_ fileName: String) -> Int? {
        return contentQueue.sync {
            filenameMap [fileName]
        }
    }
    
    func removeContent (_ content: [Content])-> [Content] {
        
        return contentQueue.sync {
            let idxs = content.reduce(into: [Int] ()) {
                accum, content in
                if let idx = filenameMap [content.fileName] {
                    accum.append(idx)
                }
            }.sorted().reversed()
            
            let removed = idxs.reduce(into: [Content] ()) {accum, idx in
                accum.append(contents.remove(at: idx))
            }
            
            _filenameMap = nil
            
            return removed
        }
    }
}
