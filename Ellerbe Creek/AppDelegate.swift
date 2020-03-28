//
//  AppDelegate.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/3/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import GameKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        createAndDisplayRootViewController()
        return true
    }

    func createAndDisplayRootViewController() {
        let dependencyContainer = DependencyContainer()
        
        let isOnboardingCompleted = UserDefaults.standard.bool(forKey: "ONBOARDING_COMPLETED")
        if isOnboardingCompleted {
            let gameMapViewController = dependencyContainer.makeGameMapViewController()
            dependencyContainer.navigationController.viewControllers = [gameMapViewController]
            setWindow(rootViewController: dependencyContainer.navigationController)
            
            GKLocalPlayer.local.authenticateHandler = { gcAuthVC, error in
                if GKLocalPlayer.local.isAuthenticated {
                    print("Game Center Authenticated")
                } else if let vc = gcAuthVC {
                    UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true)
                } else {
                    print("Error authentication to GameCenter: " + "\(error?.localizedDescription ?? "none")")
                }
            }
            
            databaseManager.fetchData(from: .preserves)
        } else {
            let onboardingViewController = dependencyContainer.makeOnboardingViewController()
            setWindow(rootViewController: onboardingViewController)
        }
    }
    
    func setWindow(rootViewController: UIViewController) {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "EllerbeCreek")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}

