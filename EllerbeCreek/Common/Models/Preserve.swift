//
//  Preserve.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/5/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import Foundation
import CoreLocation

struct Preserve: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case center
        case bounds
        case sightings
    }
    
    let id: Int?
    let name: String?
    let center: CLLocationCoordinate2D?
    let bounds: PreserveBounds?
    let sightings: [Sighting]?
    
    init(id: Int? = nil, name: String? = nil, center: CLLocationCoordinate2D? = nil, bounds: PreserveBounds? = nil, sightings: [Sighting]? = nil) {
        self.id = id
        self.name = name
        self.center = center
        self.bounds = bounds
        self.sightings = sightings
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let center = try container.decode(CLLocationCoordinate2D.self, forKey: .center)
        let bounds = try container.decode(PreserveBounds.self, forKey: .bounds)
        let sightings = try container.decode([Sighting].self, forKey: .sightings)
        
        self.init(id: id, name: name, center: center, bounds: bounds, sightings: sightings)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(center, forKey: .center)
        try container.encode(bounds, forKey: .bounds)
        try container.encode(sightings, forKey: .sightings)
    }
    
}

struct PreserveBounds: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case ne
        case sw
    }
    
    let ne: CLLocationCoordinate2D
    let sw: CLLocationCoordinate2D
    
    init(ne: CLLocationCoordinate2D, sw: CLLocationCoordinate2D) {
        self.ne = ne
        self.sw = sw
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let ne = try container.decode(CLLocationCoordinate2D.self, forKey: .ne)
        let sw = try container.decode(CLLocationCoordinate2D.self, forKey: .sw)
           
        self.init(ne: ne, sw: sw)
    }
       
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ne, forKey: .ne)
        try container.encode(sw, forKey: .sw)
    }
    
}


