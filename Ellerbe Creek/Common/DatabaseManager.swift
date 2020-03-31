//
//  DatabaseManager.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 3/21/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import UserNotifications
import AnyCodable

enum DatabaseType: String {
    case animals
    case preserves
    case users
}

class DatabaseManager: NSObject {
    
    static let shared = DatabaseManager()
    
    // MARK: Public Properties
    
    var reference: DatabaseReference? {
        didSet {
            reference?.observe(.childChanged, with: { (snapshot) in
                print(snapshot)
            })
        }
    }
    
    var managedContext: NSManagedObjectContext?
    
    var locationNotificationScheduler: LocationNotificationScheduler? {
        didSet {
            locationNotificationScheduler?.delegate = self
        }
    }
    
    // MARK: Public Functions
    
    func fetchData(from databaseType: DatabaseType) {
        sync(databaseType) {
            self.requestLocationNotifications()
        }
    }
    
    func loadData(from databaseType: DatabaseType) -> [Any] {
        switch databaseType {
        case .animals:
            return loadAnimals()
        case .preserves:
            return loadPreserves()
        default:
            break
        }
        
        return []
    }
    
    // MARK: Private Functions
    
    private func sync(_ databaseType: DatabaseType, completion: @escaping () -> Void) {
        guard let ref = reference else { return }
        ref.child(databaseType.rawValue).observe(.value, with: { (snapshot) in
            let objects = snapshot.children.allObjects as! [DataSnapshot]
            for object in objects {
                switch databaseType {
                case .animals:
                    self.saveAnimal(object)
                case .preserves:
                    self.savePreserve(object)
                default:
                    break
                }
            }
            completion()
        })
    }
    
    private func saveAnimal(_ object: DataSnapshot) {
        let id = Int(object.key)!
        guard !isAlreadySaved(in: .animals, for: id) else { return }
        
        let data = object.value as! [String:Any]
        guard let name = data["name"] as? String,
              let detail = data["description"] as? String,
              let infoLink = data["moreLink"] as? String,
              let points = data["points"] as? Int,
              let image = data["image"] as? String,
              let rarity = data["rarity"] as? String,
              let type = data["type"] as? String else { return }

        guard let managedContext = managedContext else { return }
        let entity = NSEntityDescription.entity(forEntityName: "ManagedAnimal", in: managedContext)!

        let animalObject = NSManagedObject(entity: entity, insertInto: managedContext)
        animalObject.setValue(id, forKey: "id")
        animalObject.setValue(name, forKey: "name")
        animalObject.setValue(detail, forKey: "detail")
        animalObject.setValue(infoLink, forKey: "infoLink")
        animalObject.setValue(points, forKey: "points")
        animalObject.setValue(image, forKey: "image")
        animalObject.setValue(rarity, forKey: "rarity")
        animalObject.setValue(type, forKey: "type")

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save Animal object. \(error), \(error.userInfo)")
        }
    }
        
    private func savePreserve(_ object: DataSnapshot) {
        let id = Int(object.key)!
        guard !isAlreadySaved(in: .preserves, for: id) else { return }
        
        let data = object.value as! [String:Any]
        guard let name = data["name"] as? String,
              let center = data["center"] as? [Double],
              let bounds = data["bounds"] as? [String:[Double]],
              let animals = data["animals"] as? [AnyCodable] else { return }

        guard let managedContext = managedContext else { return }
        let entity = NSEntityDescription.entity(forEntityName: "ManagedPreserve", in: managedContext)!

        let preserveObject = NSManagedObject(entity: entity, insertInto: managedContext)
        preserveObject.setValue(id, forKey: "id")
        preserveObject.setValue(name, forKeyPath: "name")
        preserveObject.setValue(center, forKeyPath: "center")
        preserveObject.setValue(bounds, forKey: "bounds")
        preserveObject.setValue(animals, forKey: "animals")

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save Preserve object. \(error), \(error.userInfo)")
        }
    }
    
    private func loadAnimals() -> [Any] {
        guard let managedContext = managedContext else { return [] }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ManagedAnimal")
        
        var animals = [Animal]()
        do {
            let objects = try managedContext.fetch(fetchRequest)

            objects.forEach { object in
                let id = object.value(forKey: "id") as! Int
                let name = object.value(forKey: "name") as! String
                let detail = object.value(forKey: "detail") as! String
                let infoLink = object.value(forKey: "infoLink") as! String
                let points = object.value(forKey: "points") as! Int
                let image = object.value(forKey: "image") as! String
                let rarity = object.value(forKey: "rarity") as! String
                let type = object.value(forKey: "type") as! String
                
                let animal = Animal(id: id, name: name, detail: detail, infoLink: infoLink, points: points, image: image, rarity: rarity, type: type)
                animals.append(animal)
            }
        } catch let error as NSError {
            print("Could not load Preserve objects. \(error), \(error.userInfo)")
        }
        
        return animals
    }
    
    private func loadPreserves() -> [Any] {
        guard let managedContext = managedContext else { return [] }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ManagedPreserve")
        
        var preserves = [Preserve]()
        do {
            let objects = try managedContext.fetch(fetchRequest)

            objects.forEach { object in
                let id = object.value(forKey: "id") as! Int
                let name = object.value(forKey: "name") as! String
                let center = object.value(forKey: "center") as! [Double]
                let bounds = object.value(forKey: "bounds") as! [String:[Double]]
                let animals = object.value(forKey: "animals") as! [AnyCodable]
                
                let preserve = Preserve(id: id, name: name, center: center, bounds: bounds, animals: animals)
                preserves.append(preserve)
            }
        } catch let error as NSError {
            print("Could not load Preserve objects. \(error), \(error.userInfo)")
        }
        
        return preserves
    }
    
    private func requestLocationNotifications() {
        let preserves = loadPreserves() as! [Preserve]
        for preserve in preserves {
            let notificationID = "preserve_\(preserve.id)_notification_id"
            let locationID = "preserve_\(preserve.id)_location_id"
            
            isNotificationAlreadyRequested(for: notificationID) { isAlreadyRequested in
                if !isAlreadyRequested {
                    let notificationInfo = LocationNotificationInfo(notificationID: notificationID,
                                                                    locationID: locationID,
                                                                    radius: 1610.0,
                                                                    latitude: preserve.center[0],
                                                                    longitude: preserve.center[1],
                                                                    title: "You're Near a Preserve",
                                                                    body: "Check out \(preserve.name) Preserve for a quick game.",
                                                                    data: nil)
                    self.requestLocationNotifition(with: notificationInfo)
                }
            }
        }
    }
    
    private func requestLocationNotifition(with notificationInfo: LocationNotificationInfo) {
        guard let locationNotificationScheduler = locationNotificationScheduler else { return }
        locationNotificationScheduler.requestNotification(with: notificationInfo)
    }
    
    private func isAlreadySaved(in databaseType: DatabaseType, for id: Int) -> Bool {
        guard let managedContext = managedContext else { return false }
        var fetchRequest = NSFetchRequest<NSManagedObject>()
        
        switch databaseType {
        case .animals:
            fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ManagedAnimal")
        case .preserves:
            fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ManagedPreserve")
        default:
            return false
        }
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)

        do {
            let objects = try managedContext.fetch(fetchRequest)
            return !objects.isEmpty
        } catch let error as NSError {
            print("Could not load Preserve objects. \(error), \(error.userInfo)")
        }
        
        return false
    }
    
    private func isNotificationAlreadyRequested(for notificationID: String, completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                if request.identifier == notificationID {
                    completion(true)
                }
            }
        })
        completion(false)
    }
    
}

extension DatabaseManager: LocationNotificationSchedulerDelegate {
    
    func notificationPermissionDenied() {
        print("The location permission was not authorized. Please enable it in Settings to continue.")
    }
    
    func locationPermissionDenied() {
        print("The notification permission was not authorized. Please enable it in Settings to continue.")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response.notification.request.identifier)
    }
    
    func notificationScheduled(error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("Notification Successfully Scheduled")
        }
    }
    
}
