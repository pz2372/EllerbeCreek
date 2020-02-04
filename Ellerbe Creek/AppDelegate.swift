//
//  AppDelegate.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/3/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        createAndDisplayRootViewController()
        return true
    }

    func createAndDisplayRootViewController() {
        let dependencyContainer = DependencyContainer()
        let gameMapViewController = dependencyContainer.makeGameMapViewController()
        dependencyContainer.navigationController.viewControllers = [gameMapViewController]
        setWindow(rootViewController: dependencyContainer.navigationController)
    }
    
    func setWindow(rootViewController: UIViewController) {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()
    }

}

