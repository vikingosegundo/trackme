//
//  ImageTableViewControllerFactory.swift
//  ImageFetcher
//
//  Created by Manuel Meyer on 10.04.17.
//  Copyright © 2017 Manuel Meyer. All rights reserved.
//

import UIKit
import TaCoPopulator


class ProjectListViewControllerFactory: ViewControllerFactoryType {
    
    init(projectSelected: @escaping (Project) -> Void){
        self.projectSelected = projectSelected
    }
    
    let projectSelected: (Project) -> Void
    
    func viewController(with creator: ViewControllerFactoryCreator) throws -> UIViewController {
        let vc = PopulatedTableViewController(nibName: "PopulatedTableViewController", bundle: nil)
        vc.populator = ProjectOverviewListPopulator(projectController: creator.projectController, didSelectProject: projectSelected)
        return vc
    }
}

class AddProjectViewControllerFactory: ViewControllerFactoryType {
    func viewController(with creator: ViewControllerFactoryCreator) throws -> UIViewController {
        let vc = AddProjectViewController(nibName: "AddProjectViewController", bundle: nil)
        vc.projectController = creator.projectController
        return vc
    }
}

class ProjectDetailViewControllerFactory: ViewControllerFactoryType {
    init(project: Project) {
        self.project = project
    }
    let project: Project
    func viewController(with creator: ViewControllerFactoryCreator) throws -> UIViewController {
        let vc = PopulatedTableViewController(nibName: "PopulatedTableViewController", bundle: nil)
        vc.title = project.title
        let pop = DetailProjectPopulator<UITableView>(project: project, projectController: creator.projectController)
        vc.populator = pop
        return vc
    }
}
