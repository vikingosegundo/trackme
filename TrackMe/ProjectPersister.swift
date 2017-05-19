//
//  ProjectDiskPersister.swift
//  TrackMe
//
//  Created by Manuel Meyer on 11.04.17.
//  Copyright © 2017 Manuel Meyer. All rights reserved.
//

import Foundation

protocol ProjectPersisterType {
    func fetchAllProjects(_: @escaping (FetchResult<[Project]>) -> Void)
    func add(project: Project, callback: @escaping (WriteResult<Project>) -> Void)
    func update(project: Project, callback: @escaping (WriteResult<Project>) -> Void)
}


enum ProjectDiskPersisterError: Error {
    case incorrectFolderPath(String)
    case pathIsNotPointingToFolder(String)
    case fetchingFailed(String)
    case couldNotWriteToDisk(String)
    case couldNotSerialize(String)
}


class ProjectDiskPersister: ProjectPersisterType {
    
    init(folderPath: String, fileManager: FileManagerType = FileManager.default, projectWriter: ProjectDataWriterType = ProjectDataWriter()) throws {
        let url = URL(fileURLWithPath: folderPath)
        self.folderURL = url.appendingPathComponent("projects", isDirectory: true)
    
        self.fileManager = fileManager
        self.projectWriter = projectWriter
        try createFolderIfNeeded()
    }
    
    let fileManager: FileManagerType
    let projectWriter: ProjectDataWriterType
    let folderURL: URL
    var projects = [Project]()
    
    private func createFolderIfNeeded() throws {
        var isDir: ObjCBool = false
        if fileManager.fileExists(atPath: folderURL.absoluteString, isDirectory:&isDir) {
            if isDir.boolValue {
                return
            } else {
                throw ProjectDiskPersisterError.pathIsNotPointingToFolder("path \(folderURL.absoluteString) does not point to folder")
            }
        } else {
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    func fetchAllProjects(_ callback: @escaping (FetchResult<[Project]>) -> Void) {
        let contents = try? fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
        guard let folderContents = contents else {
            callback(.failure(ProjectDiskPersisterError.fetchingFailed("Could not fetch from \(folderURL.absoluteString)")))
            return
        }
        self.projects = []
        for url in folderContents {
            do {
                let data = try Data(contentsOf: url)
                let dict = try PropertyListSerialization.propertyList(from: data, options: [], format: nil)
                if let projectDict = dict as? [String : Any?] {
                    self.projects.append(try Project(with: projectDict))
                }
            } catch (let error){
                print(error.localizedDescription)
            }
        }
        callback(.success(self.projects))
    }
    
    func writeProjectToDisk(project: Project, callback: @escaping (WriteResult<Project>) -> Void) {
       projectWriter.write(project: project, to: folderURL.appendingPathComponent(project.uniqueIdentifier.uuidString), callback: callback)
    }
    
    func add(project: Project, callback: @escaping (WriteResult<Project>) -> Void) {
        writeProjectToDisk(project: project){ [weak self] result in
            guard let `self` = self else {
                return
            }
            switch result {
            case .success(let p):
                self.projects.append(p)
                callback(.success(p))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
    
    func update(project: Project, callback: @escaping (WriteResult<Project>) -> Void) {
        if let index = projects.index(where: {
            return $0.uniqueIdentifier == project.uniqueIdentifier
        }) {
            projects[index] = project
            writeProjectToDisk(project: project, callback: callback)
        }
    }
}
