//
//  GameMapViewController.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/3/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import CoreLocation

protocol GameMapViewControllerDelegate: class {
    func checkForPreserves(near userLocation: CLLocation) -> Preserve?
    func presentSighting()
}

class GameMapViewController: UIViewController, NibLoadable {
    
    // MARK - Constants
    
    private let navigator: GameMapNavigator
    private let storage: Storage
    private let gameMapView: GameMapView = GameMapView()
    
    // MARK - Variables
    
    var ref: DatabaseReference!
    var preserves: [Preserve] = []
    private var profileButton: UIBarButtonItem! {
        let button = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 36.0, height: 36.0))
        button.setTitle("", for: .normal)
        button.setBackgroundImage(UIImage(named: "User"), for: .normal)
        button.addTarget(self, action: #selector(profileButtonAction), for: .touchUpInside)
        
        return UIBarButtonItem(customView: button)
    }
    
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
        self.title = "Find a Preserve"
        
        ref = Database.database().reference()
        fetchPreserves()
        navigationItem.leftBarButtonItem = profileButton
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
    @objc private func profileButtonAction() {
//        navigator.navigate(to: .profile)
        let alertController = UIAlertController(title: "User", message: "\(GCHelper.sharedInstance.getLocalUser())", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

}

extension GameMapViewController: GameMapViewControllerDelegate {
    
    func checkForPreserves(near userLocation: CLLocation) -> Preserve? {
        if !preserves.isEmpty {
            for preserve in preserves {
                let preserveLocation = CLLocation(latitude: preserve.center[0], longitude: preserve.center[1])
                let distance = userLocation.distance(from: preserveLocation)
                
                if distance < 1610.0 {
                    self.title = preserve.name + " Preserve"
                    return preserve
                } else {
                    self.title = "Find a Preserve"
                }
            }
        }
        
        return nil
    }
    
    func presentSighting() {
        navigator.present(.sighting)
    }
}
