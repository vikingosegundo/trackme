//
//  AppDelegate.swift
//  ImageFetcher
//
//  Created by Manuel Meyer on 09.04.17.
//  Copyright © 2017 Manuel Meyer. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private var appWireframe: AppWireframe
    
    override init() {
        self.appWireframe = AppWireframe()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        appWireframe.startApp()
        return true
    }
}
