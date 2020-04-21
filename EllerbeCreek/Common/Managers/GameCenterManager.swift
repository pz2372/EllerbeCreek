//
//  GameCenterManager.swift
//  EllerbeCreek
//
//  Created by Ryan Anderson on 4/16/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import Foundation
import GameKit

class GameCenterManager {
    
    static let shared = GameCenterManager()
    
    // MARK: Public Properties
    
    public var isAuthenticated: Bool {
        return GKLocalPlayer.local.isAuthenticated
    }
    
    public var localPlayerID: String {
        return GKLocalPlayer.local.playerID
    }
    
    public var localPlayerDisplayName: String {
        return GKLocalPlayer.local.displayName
    }
    
    // MARK: Public Methods
    
    public func authenticate(completion: (() -> ())? = nil) {
        let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = { (viewController, error) in
            if localPlayer.isAuthenticated {
                if let user = DatabaseManager.users.fetchLocalUser() {
                    self.userExistsLocally(user)
                } else {
                    DatabaseManager.users.fetch(for: localPlayer.playerID) { [weak self] (user, error) in
                        guard let self = self else { return }
                        if let user = user {
                            self.userExistsRemotely(user)
                        } else {
                            self.userDoesNotExist(for: localPlayer)
                        }
                    }
                }
                completion?()
            } else if let vc = viewController {
                if let rootController = UIApplication.shared.keyWindow?.rootViewController {
                    rootController.present(vc, animated: true)
                }
            } else if let error = error {
                print("Game Center Auth Error: \(error)")
            }
        }
    }
    
    // MARK: Private Methods
    
    private func didDisplayNameChange(from currentDisplayName: String) -> Bool {
        return currentDisplayName != GKLocalPlayer.local.displayName
    }
    
    private func updateDisplayNameIfNeeded(for user: User) {
        if self.didDisplayNameChange(from: user.displayName) {
            var updatedUser = user
            updatedUser.displayName = GKLocalPlayer.local.displayName
            DatabaseManager.users.update(updatedUser) { (success, error) in
                if success {
                    print("User Successfully Updated")
                } else if let error = error {
                    print(error)
                }
            }
        }
    }
    
    private func userExistsLocally(_ user: User) {
        updateDisplayNameIfNeeded(for: user)
    }
    
    private func userExistsRemotely(_ user: User) {
        updateDisplayNameIfNeeded(for: user)
    }
   
    private func userDoesNotExist(for localPlayer: GKLocalPlayer) {
        let user = User(playerID: localPlayer.playerID, displayName: localPlayer.displayName)
        DatabaseManager.users.save(user) { (success, error) in
            if success {
                print("User Successfully Saved")
            } else if let error = error {
                print(error)
            }
        }
    }
    
}
