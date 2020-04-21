//
//  CLLocation+Codable.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 4/13/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import CoreLocation

extension CLLocation: Encodable {
    private enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }
}

struct Location: Codable {
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
}

extension CLLocation {
    convenience init(model: Location) {
        self.init(latitude: model.latitude, longitude: model.longitude)
    }
}
