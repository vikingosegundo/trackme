//
//  ProjectDiskPersisterSpec.swift
//  TrackMe
//
//  Created by Manuel Meyer on 16.04.17.
//  Copyright © 2017 Manuel Meyer. All rights reserved.
//

import Quick
import Nimble
@testable import TrackMe


class ProjectDiskPersisterSpec: QuickSpec {
    
    override func spec() {
        context("success"){
            let persister = try! ProjectDiskPersister(folderPath: "path", fileManager: FileManagerMock(fileExists: true, pathDirectory: true), projectWriter: ProjectDataWriterMock())
            it("successfully adding project"){
                
                var successfullyWrittenProject: Project?
                persister.add(project: Project(title: "Project 2"), callback: { (response) in
                    switch response {
                    case .failure(_):
                        break
                    case .success(let p):
                        successfullyWrittenProject = p
                    }
                })
                expect(successfullyWrittenProject).toNot(beNil())
                expect(successfullyWrittenProject?.title).to(equal("Project 2"))
            }
            
            it("successfully updating project"){
                let project = Project(title: "Project 3")
                persister.add(project: project, callback: { _ in
                })
                
                var updatedProject: Project?
                persister.update(project: Project(title: project.title, workingSessions: [WorkingSession(startDate: Date(), endDate: nil)], uniqueIdentifier: project.uniqueIdentifier), callback: { (response) in
                    switch response {
                    case .success(let p):
                        updatedProject = p
                    default: break
                    }
                })
                
                expect(updatedProject).toNot(beNil())
                expect(updatedProject!.uniqueIdentifier) == project.uniqueIdentifier
                expect(updatedProject!.workingSessions.count) == project.workingSessions.count + 1
            }
        }
        
        
        context("failures"){
            it("path does not point to dictionary"){
                expect{
                    try ProjectDiskPersister(folderPath: "path", fileManager: FileManagerMock(fileExists: true, pathDirectory: false), projectWriter: ProjectDataWriterMock())
                    }.to(throwError(errorType: ProjectDiskPersisterError.self))
            }
            
            it("writing Project fails"){
                let persister = try! ProjectDiskPersister(folderPath: "path", fileManager: FileManagerMock(fileExists: true, pathDirectory: true), projectWriter: ProjectDataWriterMock(error: ProjectDiskPersisterError.couldNotSerialize("could not serialize")))
                
                var error: Error?
                persister.add(project: Project(title:"P"), callback: { (response) in
                    switch response {
                        
                    case .failure(let e):
                        error = e
                    case .success(_):
                        break
                    }
                })
                
                expect(error).toNot(beNil())
                expect(error).to(matchError(ProjectDiskPersisterError.couldNotSerialize("could not serialize")))
            }
        }
        
    }
}
