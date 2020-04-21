//
//  Animal.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 3/24/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import Foundation
import UIKit

enum AnimalRarity: String, Codable {
    case low
    case medium
    case high
}

enum AnimalType: String, Codable {
    case amphibian
    case bird
    case fish
    case invertebrate
    case mammal
    case reptile
}

struct Animal: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case infoLink
        case type
        case rarity
    }
    
    let id: Int?
    let name: String?
    let description: String?
    let infoLink: String?
    let type: AnimalType?
    let rarity: AnimalRarity?
    
    init(id: Int? = nil, name: String? = nil, description: String? = nil, infoLink: String? = nil, type: AnimalType? = nil, rarity: AnimalRarity? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.infoLink = infoLink
        self.type = type
        self.rarity = rarity
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let description = try container.decode(String.self, forKey: .description)
        let infoLink = try container.decode(String.self, forKey: .infoLink)
        let type = try container.decode(AnimalType.self, forKey: .type)
        let rarity = try container.decode(AnimalRarity.self, forKey: .rarity)
              
        self.init(id: id, name: name, description: description, infoLink: infoLink, type: type, rarity: rarity)
    }
          
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(infoLink, forKey: .infoLink)
        try container.encode(type, forKey: .type)
        try container.encode(rarity, forKey: .rarity)
    }
    
    public var image: UIImage? {
        guard let name = name else { return nil }
        let imageName = name.filter { !$0.isNewline && !$0.isWhitespace }
        let image = UIImage(named: "\(imageName)")
        return image
    }
}
