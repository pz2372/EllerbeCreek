//
//  Notification+Names.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 4/15/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

extension Notification.Name {
    
    static let sessionStarted = Notification.Name("session-started")
    static let sessionEnded = Notification.Name("session-ended")
    static let sessionSightingsUpdated = Notification.Name("session-sightings-updated")
    
}
