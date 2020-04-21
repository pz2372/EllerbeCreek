//
//  PermissionsHelper.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 3/24/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications
import AVFoundation

class PermissionsHelper {
    
    static let shared = PermissionsHelper()
    
    public var isLocationPermissionEnabled: Bool {
        return checkLocationPermission()
    }
    
    public var isNotificationPermissionEnabled: Bool {
        return checkNotificationPermission()
    }
    
    public var isCameraPermissionEnabled: Bool {
        return checkCameraPermission()
    }
    
    init() {}
    
    public func askForLocationPermission() {
        let locationManager = CLLocationManager()
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    public func askForNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: { (_,_) in })
    }
    
    public func askForCameraPermission() {
        guard checkCameraPermission() else { return }
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (_) in })
    }
    
    private func checkLocationPermission() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    private func checkNotificationPermission() -> Bool {
        guard let notificationSettings = UIApplication.shared.currentUserNotificationSettings else { return false }
        return notificationSettings.types.contains(.alert)
    }
    
    private func checkCameraPermission() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }
    
}



