//
//  LocationNotificationScheduler.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 3/21/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import CoreLocation
import UserNotifications

class LocationNotificationScheduler {
    
    // MARK: Public Properties
    
    weak var delegate: LocationNotificationSchedulerDelegate? {
        didSet {
            UNUserNotificationCenter.current().delegate = delegate
        }
    }
    
    // MARK: Private Properties
    
    private let locationManager = CLLocationManager()
    
    // MARK: Public Functions
    
    func requestNotification(with notificationInfo: LocationNotificationInfo) {
        if PermissionsHelper.shared.isLocationPermissionEnabled {
            askForNotificationPermissions(notificationInfo: notificationInfo)
        } else {
            delegate?.locationPermissionDenied()
        }
    }
    
    // MARK: Private Functions
    
    private func askForNotificationPermissions(notificationInfo: LocationNotificationInfo) {
        guard CLLocationManager.locationServicesEnabled() else { return }
        
        if PermissionsHelper.shared.isNotificationPermissionEnabled {
            requestNotification(notificationInfo: notificationInfo)
        } else {
            delegate?.notificationPermissionDenied()
        }
    }
    
    private func requestNotification(notificationInfo: LocationNotificationInfo) {
        let notification = notificationContent(for: notificationInfo)
        let destRegion = destinationRegion(for: notificationInfo)
        let trigger = UNLocationNotificationTrigger(region: destRegion, repeats: true)
        
        let request = UNNotificationRequest(identifier: notificationInfo.notificationID, content: notification, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { [weak self] (error) in
            DispatchQueue.main.async {
                print(request.identifier)
                self?.delegate?.notificationScheduled(error: error)
            }
        })
        
    }
    
    private func notificationContent(for notificationInfo: LocationNotificationInfo) -> UNMutableNotificationContent {
        let notification = UNMutableNotificationContent()
        notification.title = notificationInfo.title
        notification.body = notificationInfo.body
        notification.sound = UNNotificationSound.default
        
        if let data = notificationInfo.data {
            notification.userInfo = data
        }
        
        return notification
    }
    
    private func destinationRegion(for notificationInfo: LocationNotificationInfo) -> CLCircularRegion {
        let destRegion = CLCircularRegion(center: notificationInfo.coordinates, radius: notificationInfo.radius, identifier: notificationInfo.locationID)
        destRegion.notifyOnEntry = true
        destRegion.notifyOnExit = false
        
        return destRegion
    }
    
}
