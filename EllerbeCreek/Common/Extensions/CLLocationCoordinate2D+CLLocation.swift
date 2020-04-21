//
//  CLLocationCoordinate2D+CLLocation.swift
//  EllerbeCreek
//
//  Created by Ryan Anderson on 4/18/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    
    public var location: CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
    
}
