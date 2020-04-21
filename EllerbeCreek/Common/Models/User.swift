//
//  User.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/4/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import Foundation


struct User: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case playerID
        case displayName
        case sessions
        case createDate
    }
    
    var id: String
    var playerID: String
    var displayName: String
    var sessions: [Session]
    var createDate: String
    
    init(id: String = "", playerID: String, displayName: String, sessions: [Session] = [Session](), createDate: String = "") {
        self.id = id
        self.playerID = playerID
        self.displayName = displayName
        self.sessions = sessions
        self.createDate = createDate
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let id = try values.decode(String.self, forKey: .id)
        let playerID = try values.decode(String.self, forKey: .playerID)
        let displayName = try? values.decode(String.self, forKey: .displayName)
        let sessions = try? values.decode([Session].self, forKey: .sessions)
        let createDate = try? values.decode(String.self, forKey: .createDate)
        
        self.init(id: id, playerID: playerID, displayName: displayName ?? "", sessions: sessions ?? [Session](), createDate: createDate ?? "")
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(playerID, forKey: .playerID)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(sessions, forKey: .sessions)
        try container.encode(createDate, forKey: .createDate)
    }
    
}
