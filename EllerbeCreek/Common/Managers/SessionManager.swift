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
    
    public private(set) var session: Session?
    
    public var preserve: Preserve? {
        return session?.preserve
    }
    
    public var isSessionInProgress: Bool {
        return session != nil
    }
    
    // MARK: Private Properties
    
    private let dateFormatter =  DateFormatter()
    
    init() {
        dateFormatter.dateFormat = "MMMM-dd-yyyy"
    }
    
    // MARK: Public Functions
    
    public func start(at preserve: Preserve) {
        guard session == nil else { return }
        session = Session(date: Date(), preserve: preserve, sightings: [Sighting]())
        
        NotificationCenter.default.post(name: .sessionStarted, object: nil)
    }
    
    public func addSighting(_ sighting: Sighting) {
        guard session != nil else { return }
        session?.sightings.append(sighting)
        
        NotificationCenter.default.post(name: .sessionSightingsUpdated, object: nil)
    }
    
    public func end() {
            guard let session = self.session else { return }
            self.save(session) {
                self.session = nil
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .sessionEnded, object: nil)
                }
            }
    }
    
    // MARK: Private Functions
    
    private func save(_ session: Session, completion: @escaping (() -> ())) {
        if let user = DatabaseManager.users.fetchLocalUser() {
            if !session.sightings.isEmpty {
                var updatedUser = user
                updatedUser.sessions.append(session)
                
                DatabaseManager.users.update(updatedUser) { (success, error) in
                    if success {
                        print("User Successfully Updated")
                        completion()
                    } else if let error = error {
                        print(error)
                        completion()
                    }
                }
            } else {
                completion()
            }
        }
    }
    
}
