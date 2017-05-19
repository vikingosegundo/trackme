//
//  CommonTypes.swift
//  TrackMe
//
//  Created by Manuel Meyer on 17.04.17.
//  Copyright © 2017 Manuel Meyer. All rights reserved.
//

import Foundation

enum FetchResult<T> {
    case success(T)
    case failure(Error)
}

enum WriteResult<T> {
    case success(T)
    case failure(Error)
}

protocol DictionaryRepresentable {
    var dictionaryRepresentation: [String: Any?] { get }
    init(with dictionary: [String:Any?]) throws
}

enum SerialisationError: Error {
    case deserialisationFailed(String)
}
