//
//  ContentBucket.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 01/11/2018.
//  Copyright © 2018 Colin Wilson. All rights reserved.
//

import Foundation


///=================================================================================
/// A content bucket contains an array of Contents of the same kind
class ContentBucket {
    let name: String
    private (set) var contents = [Content] ()
    private var _filenameMap : [String:Int]?
    
    ///----------------------------------------------------------------------------
    /// init
    ///
    /// - Parameters:
    ///   - name: The bucket name, eg. Photos
    init (name: String) {
        self.name = name
    }
    
    ///----------------------------------------------------------------------------
    /// addContent
    ///
    /// - Parameter content: The content to add
    func addContent (_ content: Content) {
        contents.append(content)
        
        if _filenameMap != nil {
            _filenameMap! [content.fileName] = contents.count-1
        }
    }
    
    ///----------------------------------------------------------------------------
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
    
    ///----------------------------------------------------------------------------
    /// getIndexForFilename
    ///
    /// - Parameter fileName: The file name
    /// - Returns: The index of the contents array
    func getIndexForFilename (_ fileName: String) -> Int? {
        return filenameMap [fileName]
    }
}
