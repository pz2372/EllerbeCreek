//
//  LocationNotificationSchedulerDelegate.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 3/21/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UserNotifications

protocol LocationNotificationSchedulerDelegate: UNUserNotificationCenterDelegate {
    
    // Called when the user has denied the notification permission prompt
    func notificationPermissionDenied()
    
    // Called when the user has denied the location permission prompt
    func locationPermissionDenied()
    
    // Called when the notification request completed
    func notificationScheduled(error: Error?)
}
