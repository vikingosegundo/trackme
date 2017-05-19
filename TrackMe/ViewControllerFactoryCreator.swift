//
//  ViewControllerFactoryCreator.swift
//  ImageFetcher
//
//  Created by Manuel Meyer on 10.04.17.
//  Copyright © 2017 Manuel Meyer. All rights reserved.
//

import UIKit

protocol ViewControllerFactoryType {
    func viewController(with creator: ViewControllerFactoryCreator) throws -> UIViewController
}

final
class ViewControllerFactoryCreator {
    init(projectController: ProjectControllerType) {
        self.projectController = projectController
    }
    let projectController: ProjectControllerType
    
    func create(with factory: ViewControllerFactoryType) throws -> UIViewController {
        return try factory.viewController(with: self)
    }
}
