//
//  OverviewListPopulator.swift
//  TrackMe
//
//  Created by Manuel Meyer on 11.04.17.
//  Copyright © 2017 Manuel Meyer. All rights reserved.
//

import Foundation
import TaCoPopulator


class ProjectsProvider: SectionDataProvider<Project>, ObserverType, Observable {
    init(projectController: ProjectControllerType, reuseIdentifer: @escaping (Project, IndexPath) -> String) {
        self.projectController = projectController
        super.init(reuseIdentifer: reuseIdentifer)
        projectController.register(observer: self)
    }
    
    deinit {
        self.projectController.unregister(observer: self)
    }
    
    let projectController: ProjectControllerType
    var uniqueIdentifier: UUID = UUID()
    var observers: [ObserverType] = []
    
    func updated(observable: Observable){
        if let projectController = observable as? ProjectControllerType {
            self.provideElements(projectController.allProjects(sortedBy: .az))
        }
    }   
}

class ProjectOverviewListPopulator<View: PopulatorView>: Populator<View>, ObserverType {
    
    init(projectController: ProjectControllerType, didSelectProject: @escaping (Project) -> Void) {
        self.projectController = projectController
        self.didSelectProject = didSelectProject
    }
    deinit {
        self.section0Provider?.unregister(observer: self)
    }
    
    let didSelectProject: (Project) -> Void
    let projectController: ProjectControllerType
    var uniqueIdentifier: UUID = UUID()
    var section0Provider: ProjectsProvider?
    
    override func configure(){
        if let populatorView = self.populatorView {
            if let tableView = populatorView as? UITableView {
                tableView.register(ProjectOverviewTableViewCell.self, forCellReuseIdentifier: "Cell")
            }
            let section0Provider = ProjectsProvider(projectController:projectController) { _ in
                return "Cell"
            }
            section0Provider.register(observer: self)
            
            let cellConfigurator: ((CellConfigurationDescriptor<Project, ProjectOverviewTableViewCell>) -> ProjectOverviewTableViewCell) = {
                descriptor -> ProjectOverviewTableViewCell in
                let project = descriptor.element
                descriptor.cell.configureFor(project: project)
                return descriptor.cell
            }
            
            let section0 = SectionCellsFactory(populatorView: populatorView,
                                                    provider: section0Provider,
                                            cellConfigurator: cellConfigurator)
            
            section0Provider.selected = {
                [weak self] project, _ in
                self?.didSelectProject(project)
            }
            
            section0Provider.actionsForElement = {
                project, indexPath -> [UITableViewRowAction]? in
                if let _ = project.activeWorkingSession {
                    return [UITableViewRowAction(style: .default, title: "Stop", handler: {
                        (action, ip) in
                        _ = self.projectController.pauseRecordingWorkingSessionFor(project: project)
                    })]
                } else {
                    return [UITableViewRowAction(style: .default, title: "Start", handler: {
                        (action, ip) in
                        _ = self.projectController.startRecordingWorkingSessionFor(project: project)
                    })]
                }
                
            }
            
            self.viewPopulator = ViewPopulator(populatorView: populatorView, sectionCellModelsFactories: [section0])
            self.section0Provider = section0Provider
        }
    }
    
    func updated(observable: Observable) {
            self.populatorView?.reloadData()
    }
}
