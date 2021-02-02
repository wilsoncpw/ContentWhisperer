//
//  FastDirectoryEnumerator.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 07/11/2019.
//  Copyright © 2019 Colin Wilson. All rights reserved.
//

import Foundation

class FastDirectoryEnumerator {
    let path: String
    
    required init (path: String) {
        self.path = path
    }
    
    convenience init (url: URL) {
        self.init (path: url.path)
    }
    
    private func count (from path: String, recurse: Bool, ignoringSubdirs: [String]?) -> Int {
        let p = path.cString(using: .utf8)
        var cx = 0
        if p != nil, let d = opendir(p) {
            defer { closedir(d) }
            while let ent = readdir(d) {
                if ent.pointee.d_type != DT_DIR {
                    cx += 1
                } else if recurse, let subdir = String (bytesNoCopy: &ent.pointee.d_name, length: Int(ent.pointee.d_namlen), encoding: .utf8, freeWhenDone: false), !subdir.hasPrefix(".") {
                    
                    if ignoringSubdirs == nil || !ignoringSubdirs!.contains(subdir.lowercased()) {
                        cx += count(from: path + "/" + subdir, recurse: true, ignoringSubdirs: ignoringSubdirs)
                    }
                }
            }
        }
        return cx
    }
    
    var count: Int {
        return count(from: path, recurse: false, ignoringSubdirs: nil)
    }
    
    var deepCount: Int {
        return count(from: path, recurse: true, ignoringSubdirs: nil)
    }
    
    func deepCount (ignoringSubdirs: [String]) -> Int {
        return count(from: path, recurse: true, ignoringSubdirs: ignoringSubdirs)
    }
    
    private func getFiles (subPath: String, recurse: Bool, ignoringSubdirs: [String]) -> [String] {
        
        var rv = [String] ()
    
        rv.reserveCapacity(10000)
        
        let py = (subPath.count == 0 ? "" : subPath + "/")
        let pz = path + "/" + py
        let p = pz.cString(using: .utf8)
        if p != nil, let d = opendir(p) {
            defer { closedir(d) }
            while let ent = readdir(d) {
                
                guard let lastPathComponent = String (bytesNoCopy: &ent.pointee.d_name, length: Int(ent.pointee.d_namlen), encoding: .utf8, freeWhenDone: false), !lastPathComponent.hasPrefix(".") else {
                    continue
                }
                if ent.pointee.d_type != DT_DIR {
                    rv.append(py + lastPathComponent)
                } else if recurse &&  !ignoringSubdirs.contains(lastPathComponent.lowercased ()) {
                    rv.append(contentsOf: getFiles(subPath: py + lastPathComponent, recurse: true, ignoringSubdirs: ignoringSubdirs))
                }
            }
        }
        return rv
    }
    
    func getFiles(recurse: Bool, ignoringSubdirs: [String]) -> [String] {
        return getFiles(subPath:"", recurse: recurse, ignoringSubdirs: ignoringSubdirs)
    }
    
    
    func getURLs (recurse: Bool, ignoringSubdirs: [String]) -> [URL] {
        let rootURL = URL (fileURLWithPath: path, isDirectory: true)
        return getFiles(subPath:"", recurse: recurse, ignoringSubdirs: ignoringSubdirs).map {st in
            
            let rv = URL (fileURLWithPath: String (st.dropFirst()), relativeTo: rootURL)
            return rv
        }
    }
}
