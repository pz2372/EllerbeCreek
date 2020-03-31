//
//  SessionManager.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 3/21/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import Foundation

class SessionManager {
    
    // MARK: Public Properties
    
    static let shared = SessionManager()
    
    
    // MARK: Private Properties
    
    private var currentSession: Session?
    
    init() {}
    
    // MARK: Public Functions
    
    func start(at preserve: Preserve) {
        let date = ""
        let preserveID = preserve.id
        
        currentSession = Session(date: date, preserve: preserveID, animals: [Int:[Double]]())
    }
    
    func end() {
        saveSession()
        
        currentSession = nil
    }
    
    // MARK: Private Functions
    
    func saveSession() {
        
    }
    
}
