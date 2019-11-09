//
//  ContentLoader.swift
//  ContentWhisperer
//
//  Created by Colin Wilson on 06/11/2019.
//  Copyright © 2019 Colin Wilson. All rights reserved.
//

import Foundation


class ContentLoader {
    
    let folderURL: URL
    let contentProvider: ContentProvider
    
    init (folderURL: URL, contentProvider: ContentProvider) {
        self.folderURL = folderURL
        self.contentProvider = contentProvider
    }
    
    func load (callback: @escaping (_ result: Result<Contents, Error>) -> Void) {
        
        DispatchQueue.global().async {
            do {
                let contents = try self.asyncLoad ()
                DispatchQueue.main.async {
                    callback (.success(contents))
                }
            } catch let e {
                DispatchQueue.main.async {
                    callback (.failure(e))
                }
            }
        }
    }
    
    func asyncLoad () throws -> Contents {
//        contentProvider.countFiles(url: folderURL)
        return try Contents (contentProvider: contentProvider, folderURL: folderURL)
    }
}
