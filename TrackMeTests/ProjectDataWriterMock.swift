//
//  ProjectDataWriterMock.swift
//  
//
//  Created by Manuel Meyer on 18.04.17.
//
//

import Foundation
@testable import TrackMe

class ProjectDataWriterMock: ProjectDataWriterType {
    
    init(error: Error? = nil) {
        self.error = error
    }
    
    let error: Error?
    
    func write(project: Project, to fileURL: URL, callback: @escaping (WriteResult<Project>) -> Void) {
        if let error = self.error {
            callback(.failure(error))
        } else {
            callback(.success(project))
        }
    }
}
