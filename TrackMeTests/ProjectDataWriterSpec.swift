//
//  ProjectDataWriterSpec.swift
//  TrackMe
//
//  Created by Manuel Meyer on 16.04.17.
//  Copyright © 2017 Manuel Meyer. All rights reserved.
//

import Quick
import Nimble
@testable import TrackMe

class ProjectDataWriterSpec: QuickSpec {
    
    override func spec() {
        var projectDataWriter: ProjectDataWriterType!
        
        context("writing projects") {
            context(""){
                let folderURL = URL(fileURLWithPath:  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent("testProjects")
        
                
                beforeEach {
                    let fileManager = FileManager.default
                    
                    try? fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
                    projectDataWriter = ProjectDataWriter()
                }
                
                afterEach {
                    let fileManager = FileManager.default
                    try? fileManager.removeItem(at: folderURL)
                }
                
                it("should succesfully write"){
                    let project = Project(title: "Project 1")
                    let fileURL = folderURL.appendingPathComponent(project.uniqueIdentifier.uuidString)
                    var successFullyWrittenProject: Project?
                    projectDataWriter.write(project: project, to: fileURL, callback: { (response) in
                        switch response {
                        case .success(let project):
                            successFullyWrittenProject = project
                        default: ()
                        }
                    })
                    
                    expect(successFullyWrittenProject).toNot(beNil())
                    expect(successFullyWrittenProject?.title).to(equal("Project 1"))
                    
                }
            }
            
            context(""){
                let folderURL = URL(fileURLWithPath:"/").appendingPathComponent("testProjects")
                beforeEach {
                    let fileManager = FileManager.default
                    
                    try? fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
                    projectDataWriter = ProjectDataWriter()
                }
                
                afterEach {
                    let fileManager = FileManager.default
                    try? fileManager.removeItem(at: folderURL)
                }
                it("should not succesfully write"){
                    let project = Project(title: "Project 1")
                    let fileURL = folderURL.appendingPathComponent(project.uniqueIdentifier.uuidString)
                    var error: Error?
                    projectDataWriter.write(project: project, to: fileURL, callback: { (response) in
                        switch response {
                        case .success(_):
                            break
                        case .failure(let e):
                            error = e
                        }
                    })
                    
                    expect(error).toNot(beNil())
                    
                }
            
            }
        }
    }
}
