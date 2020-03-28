//
//  LocationNotificationInfo.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 3/21/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import CoreLocation

struct LocationNotificationInfo {
    
    // Identifiers
    let notificationID: String
    let locationID: String
    
    // Location
    let radius: Double
    let latitude: Double
    let longitude: Double
    
    // Notification
    let title: String
    let body: String
    let data: [String: Any]?
    
    // CLLocation Coordinates
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
}
