//
//  GameMapViewController.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/3/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit
import CoreData

protocol GameMapViewControllerDelegate: class {
    
}

class GameMapViewController: UIViewController, NibLoadable {
    
    // MARK - Constants
    
    private let navigator: GameMapNavigator
    private let storage: Storage
    private let gameMapView: GameMapView = GameMapView()
    
    // MARK: - UIViewController Lifecycle
    
    required init(navigator: GameMapNavigator) {
        self.navigator = navigator
        self.storage = navigator.dependencyContainer.storage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func loadView() {
        super.loadView()
        self.view = self.gameMapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.gameMapView.delegate = self
        
        // TODO: Update this title with the name of the user's current location
        self.title = "Beaver Marsh Preserve"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func fetchPreserves() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ManagedPreserve")
        do {
            let managedPreserves = try managedContext.fetch(fetchRequest)
            preserves = decodeManagedObjects(objects: managedPreserves) as! [Preserve]
            if preserves.isEmpty {
                ref.child("Preserves").observe(DataEventType.value, with: { (snapshot) in
                    let data = snapshot.value as! [Dictionary<String, Any>]
                    for d in data {
                        guard let name = d["name"] as? String else { return }
                        
                        if let bounds = d["bounds"] as? [String:[Double]], let center = d["center"] as? [Double] {
                            let newPreserve = Preserve(name: name, center: center, bounds: bounds)
                            self.savePreserve(newPreserve)
                        }
                    }
                })
            }
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    private func decodeManagedObjects(objects: [NSManagedObject]) -> [Any] {
        var tempPreserves:[Preserve] = []
        for object in objects {
            let name = object.value(forKey: "name") as! String
            let bounds = object.value(forKey: "bounds") as! [String:[Double]]
            let center = object.value(forKey: "center") as! [Double]
            
            let tempPreserve = Preserve(name: name, center: center, bounds: bounds)
            tempPreserves.append(tempPreserve)
        }
        return tempPreserves
    }
    
    private func savePreserve(_ preserve: Preserve) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "ManagedPreserve", in: managedContext)!
        
        let preserveObject = NSManagedObject(entity: entity, insertInto: managedContext)
        preserveObject.setValue(preserve.name, forKeyPath: "name")
        preserveObject.setValue(preserve.bounds, forKeyPath: "bounds")
        preserveObject.setValue(preserve.center, forKey: "center")
        
        do {
            try managedContext.save()
            preserves.append(preserve)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

}

extension GameMapViewController: GameMapViewControllerDelegate {
    
}
