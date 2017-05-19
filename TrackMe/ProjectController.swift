//
//  ProjectController.swift
//  TrackMe
//
//  Created by Manuel Meyer on 11.04.17.
//  Copyright © 2017 Manuel Meyer. All rights reserved.
//

import Foundation

protocol ProjectControllerType: Observable {
    func allProjects(sortedBy: Project.Sorting) -> [Project]
    func addProject(title: String)
    func startRecordingWorkingSessionFor(project: Project) -> Project
    func pauseRecordingWorkingSessionFor(project: Project) -> Project
    func update(project: Project)
}

class ProjectController: ProjectControllerType {
    
    init(persister: ProjectPersisterType) {
        self.persister = persister
        reload()
    }
    
    private var _allProjects: [Project] = []
    let persister: ProjectPersisterType
    var observers: [ObserverType] = []
    func allProjects(sortedBy: Project.Sorting) -> [Project] {
        switch sortedBy {
        case .az:
            return _allProjects.sorted(by: { (p1, p2) -> Bool in
                return p1.title.localizedCompare(p2.title) == .orderedAscending
            })
        case .za:
            return _allProjects.sorted(by: { (p1, p2) -> Bool in
                return p1.title.localizedCompare(p2.title) != .orderedAscending
            })
        }
    }
    
    func reload(){
        persister.fetchAllProjects { (result) in
            switch result {
            case .success(let projects):
                self._allProjects = projects
            case .failure(let error):
                print(error)
            }
            self.notifyObservers()
        }
    }
    
    func addProject(title: String) {
        persister.add(project: Project(title: title)){ result in
            switch result {
            case .success:
                self.reload()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func update(project: Project) {
        persister.update(project: project) {[weak self] _ in
            self?.reload()
        }
    }
    
    func startRecordingWorkingSessionFor(project: Project) -> Project {
        let newInterval = WorkingSession(startDate: Date(), endDate: nil)
        var intervals = project.workingSessions
        intervals.append(newInterval)
        print("\(project.title) \(intervals.count)")
        let p = Project(title: project.title, workingSessions: intervals, uniqueIdentifier: project.uniqueIdentifier)
        self.update(project: p)
        return p
    }
    
    func pauseRecordingWorkingSessionFor(project: Project) -> Project {
        var intervals = project.workingSessions
        if let lastSession = project.workingSessions.last, lastSession.endDate == nil {
            intervals.removeLast()
            intervals.append(WorkingSession(startDate: lastSession.startDate, endDate: Date()))
        }
        let p = Project(title: project.title, workingSessions: intervals, uniqueIdentifier: project.uniqueIdentifier)
        self.update(project: p)
        return p
    }
}
