//
//  FileManagerMock.swift
//  TrackMe
//
//  Created by Manuel Meyer on 18.04.17.
//  Copyright © 2017 Manuel Meyer. All rights reserved.
//

import Foundation
@testable import TrackMe

class FileManagerMock: FileManagerType {
    
    init(fileExists: Bool, pathDirectory: Bool) {
        self.fileExists = fileExists
        self.pathDirectory = pathDirectory
    }
    
    let fileExists: Bool
    let pathDirectory: Bool
    
    func fileExists(atPath path: String, isDirectory: UnsafeMutablePointer<ObjCBool>?) -> Bool {
        isDirectory?.pointee = ObjCBool(pathDirectory)
        return fileExists
    }
    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [String : Any]?) throws {
        
    }
    
    func contentsOfDirectory(at url: URL, includingPropertiesForKeys keys: [URLResourceKey]?, options mask: FileManager.DirectoryEnumerationOptions) throws -> [URL] {
        return [URL(fileURLWithPath: "")]
    }
}
