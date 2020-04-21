//
//  Sighting.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 4/13/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import Foundation
import CoreLocation

struct Sighting: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case animalID
        case location
    }
    
    let id: Int
    let animal: Animal
    let location: CLLocation
    
    init(id: Int, animal: Animal, location: CLLocation) {
        self.id = id
        self.animal = animal
        self.location = location
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let animalID = try container.decode(Int.self, forKey: .animalID)
        let location = try container.decode(Location.self, forKey: .location)
        
        var animal = Animal()
        DatabaseManager.animals.fetch { (data, error) in
            if let animals = data as? [Animal] {
                animal = animals.filter({ $0.id == animalID })[0]
            } else if let error = error {
                print(error)
            }
        }
        
        self.init(id: id, animal: animal, location: CLLocation(model: location))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(animal.id, forKey: .animalID)
        try container.encode(location, forKey: .location)
    }
    
    var points: Int {
        var value = 0
        
        switch animal.rarity {
        case .low:
            value = 3
        case .medium:
            value = 6
        case .high:
            value = 9
        case .none:
            value = 0
        }
        
        return value
    }

}
