//
//  ProjectDataWriter.swift
//  TrackMe
//
//  Created by Manuel Meyer on 16.04.17.
//  Copyright © 2017 Manuel Meyer. All rights reserved.
//

import Foundation

protocol ProjectDataWriterType {
    func write(project: Project, to fileURL: URL, callback: @escaping (WriteResult<Project>) -> Void)
}

class ProjectDataWriter: ProjectDataWriterType {
    func write(project: Project, to fileURL: URL, callback: @escaping (WriteResult<Project>) -> Void) {
        do {
            let serializedProject = try PropertyListSerialization.data(fromPropertyList: project.dictionaryRepresentation, format: .xml, options: 0)
            do {
                try serializedProject.write(to: fileURL)
            } catch  {
                callback(.failure(ProjectDiskPersisterError.couldNotWriteToDisk("could not write:\(project)")))
                return
            }
        } catch {
            callback(.failure(ProjectDiskPersisterError.couldNotSerialize("could not serialize:\(project)")))
            return
        }
        callback(.success(project))
    }
}
