//
//  AppWireframe.swift
//  ImageFetcher
//
//  Created by Manuel Meyer on 10.04.17.
//  Copyright © 2017 Manuel Meyer. All rights reserved.
//

import UIKit


class AppWireframe {

    init() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let projectController = try? ProjectController(persister: ProjectDiskPersister(folderPath: documentsPath))
        guard let pc = projectController else {
            fatalError()
        }
        self.projectController = pc
        viewControllerFactoryCreator = ViewControllerFactoryCreator(projectController: pc)
    }
    fileprivate var window: UIWindow?
    

    let projectController: ProjectControllerType
    fileprivate let viewControllerFactoryCreator: ViewControllerFactoryCreator
    
    var rootTabBarController: UITabBarController?
    
    internal func startApp() {
        self.createWindow()
        self.presentApp()
        self.window?.makeKeyAndVisible()
    }
    
    @objc func presentApp() {
        self.rootTabBarController = self.tabBarController()
        self.window?.rootViewController = self.rootTabBarController
    }

    func createWindow() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
    }
}

private
extension AppWireframe {
    @objc
    func presentProjectInput(){
        let addVC = try? viewControllerFactoryCreator.create(with: AddProjectViewControllerFactory())
        if let addVC = addVC as? AddProjectViewController {
            addVC.shouldDismiss = { [weak addVC] in
                addVC?.dismiss(animated: true, completion: nil)
            }
            window?.rootViewController?.present(addVC, animated: true, completion: nil)
        }
    }
    
    func presentProjectDetailVC(project: Project) {
        
        let detailProjectViewController = try? viewControllerFactoryCreator.create(with: ProjectDetailViewControllerFactory(project:project))
        if let navigationController  = self.rootTabBarController?.selectedViewController as? UINavigationController, let detailProjectVC = detailProjectViewController {
            navigationController.pushViewController(detailProjectVC, animated: true)
        }
    }
}

private
extension AppWireframe {
    
    func tabBarController() -> UITabBarController {
        let projectListTableViewController = try? viewControllerFactoryCreator.create(with: ProjectListViewControllerFactory(projectSelected: { [weak self](project) in
            self?.presentProjectDetailVC(project: project)
        }))
        guard let projectListViewController = projectListTableViewController as? PopulatedTableViewController else {
            fatalError()
        }
        
        let tabBarController: UITabBarController = {
            let tabBarController = UITabBarController()
            projectListViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentProjectInput))
            let childControllers = [UINavigationController(rootViewController: projectListViewController)]
            tabBarController.setViewControllers(childControllers, animated: false)
            tabBarController.selectedIndex = 0
            return tabBarController
        }()
        
        return tabBarController
    }
}
