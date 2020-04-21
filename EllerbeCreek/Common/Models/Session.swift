//
//  Session.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/4/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import Foundation
import CoreLocation

struct Session: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case date
        case preserveID
        case sightings
    }
    
    var date: Date
    var preserve: Preserve
    var sightings: [Sighting]
    
    init(date: Date, preserve: Preserve, sightings: [Sighting]) {
        self.date = date
        self.preserve = preserve
        self.sightings = sightings
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let date = try values.decode(Date.self, forKey: .date)
        let preserveID = try values.decode(Int.self, forKey: .preserveID)
        let sightings = try values.decode([Sighting].self, forKey: .sightings)
        
        var preserve = Preserve()
        DatabaseManager.preserves.fetch { (data, error) in
            if let preserves = data as? [Preserve] {
                preserve = preserves.filter({ $0.id == preserveID})[0]
            } else if let error = error {
                print(error)
            }
        }
        
        self.init(date: date, preserve: preserve, sightings: sightings)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(preserve.id, forKey: .preserveID)
        try container.encode(sightings, forKey: .sightings)
    }
    
    var totalPoints: Int {
        return sightings.map({$0.points}).reduce(0,+)
    }
    
}
