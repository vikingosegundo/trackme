//
//  FileManager+FileManagerType.swift
//  TrackMe
//
//  Created by Manuel Meyer on 16.04.17.
//  Copyright © 2017 Manuel Meyer. All rights reserved.
//

import Foundation

protocol FileManagerType {
    func fileExists(atPath path: String, isDirectory: UnsafeMutablePointer<ObjCBool>?) -> Bool
    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [String : Any]?) throws
    func contentsOfDirectory(at url: URL, includingPropertiesForKeys keys: [URLResourceKey]?, options mask: FileManager.DirectoryEnumerationOptions) throws -> [URL]
}

extension FileManager: FileManagerType {
}
