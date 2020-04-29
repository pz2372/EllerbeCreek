//
//  LocationNotificationManager.swift
//  EllerbeCreek
//
//  Created by Ryan Anderson on 4/28/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

class LocationNotificationManager: NSObject {
    
    public var locationNotificationScheduler: LocationNotificationScheduler? {
        didSet {
            locationNotificationScheduler?.delegate = self
        }
    }
    
    // MARK: Public Functions
    
    public func requestLocationNotification(for preserve: Preserve) {
        guard let preserveID = preserve.id, let preserveName = preserve.name, let preserveCenter = preserve.center else { return }
        
        let notificationID = "preserve-\(preserveID)-notification-id"
        let locationID = "preserve-\(preserveID)-location-id"
        
        isNotificationAlreadyRequested(for: notificationID) { isAlreadyRequested in
            if !isAlreadyRequested {
                let notificationInfo = LocationNotificationInfo(notificationID: notificationID,
                                                                locationID: locationID,
                                                                radius: 1610.0,
                                                                coordinates: preserveCenter,
                                                                title: "You're Near a Preserve",
                                                                body: "Check out \(preserveName) Preserve for a quick game.",
                                                                data: nil)
                self.requestNotificationInfo(with: notificationInfo)
            }
        }
    }
    
    public func requestSightingLocationNotifications(for preserve: Preserve) {
        guard let preserveSightings = preserve.sightings else { return }
        preserveSightings.forEach { sighting in
            let notificationID = "sighting-\(sighting.id)-notification-id"
            let locationID = "sighting-\(sighting)-location-id"
            
            isNotificationAlreadyRequested(for: notificationID) { isAlreadyRequested in
                if !isAlreadyRequested {
                    let notificationInfo = LocationNotificationInfo(notificationID: notificationID,
                                                                    locationID: locationID,
                                                                    radius: 1610.0,
                                                                    coordinates: sighting.location.coordinate,
                                                                    title: "Animal Nearby",
                                                                    body: "You're getting close to an animal. Come see if you can find it!",
                                                                    data: nil)
                    self.requestNotificationInfo(with: notificationInfo)
                }
            }
        }
    }
    
    public func removeSightingLocationNotifications(for preserve: Preserve) {
        guard let preserveSightings = preserve.sightings else { return }
        
        var notificationIDs = [String]()
        preserveSightings.forEach { sighting in
            let notificationID = "sighting-\(sighting.id)-notification-id"
            notificationIDs.append(notificationID)
        }
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: notificationIDs)
    }
    
    // MARK: Private Functions
    
    private func requestNotificationInfo(with notificationInfo: LocationNotificationInfo) {
        guard let locationNotificationScheduler = locationNotificationScheduler else { return }
        locationNotificationScheduler.requestNotification(with: notificationInfo)
    }
    
    private func isNotificationAlreadyRequested(for notificationID: String, completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                if request.identifier == notificationID {
                    completion(true)
                }
            }
            completion(false)
        })
    }
    
}

extension LocationNotificationManager: LocationNotificationSchedulerDelegate {
    
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
