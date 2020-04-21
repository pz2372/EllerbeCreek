//
//  DatabaseManager.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 3/21/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications


import Foundation

private protocol Database {
    func fetch(completion: @escaping (_ data: Any?, _ error: Error?)->())
}

class DatabaseManager: NSObject {
    static let animals = Animals()
    static let preserves = Preserves()
    static let users = Users()
}

extension DatabaseManager {
    
    struct Animals: Database {
        public func fetch(completion: (Any?, Error?) -> ()) {
            let animals = Bundle.main.decode([Animal].self, from: "animals")
            completion(animals, nil)
        }
    }
    
}

extension DatabaseManager {
    
    struct Preserves: Database {
        public func fetch(completion: (Any?, Error?) -> ()) {
            let preserves = Bundle.main.decode([Preserve].self, from: "preserves")
            completion(preserves, nil)
        }
    }
    
}

extension DatabaseManager {
    
    struct Users: Database {
        public let tokens = Tokens()
        
        private let network = NetworkManager()
        private let rootURL = "https://ellerbe-creek.herokuapp.com/api"
        
        public func fetch(completion: @escaping (Any?, Error?) -> ()) {
            guard let url = URL(string: "\(rootURL)/users") else { return }
            
            guard let user = fetchLocalUser() else { return }
            tokens.getToken(for: user.playerID) { (token, error) in
                guard error == nil else { return }
                guard let token = token else { return }
                self.network.requestHttpHeaders.add(value: token, forKey: "token")
                self.network.makeRequest(toURL: url, withHttpMethod: .get) { (results) in
                    guard let response = results.response else { return }
                    if response.httpStatusCode == 200 {
                        if let data = results.data {
                            do {
                                let users = try JSONDecoder().decode([User].self, from: data)
                                completion(users, nil)
                            } catch {
                                completion(nil, error)
                            }
                        }
                    } else {
                        completion(nil, NetworkManager.CustomError.failedToFetchObjects)
                    }
                }
            }
        }
        
        public func fetch(for playerID: String, completion: @escaping ((_ user: User?, _ error: Error?) -> ())) {
            guard let url = URL(string: "\(rootURL)/users/\(playerID)") else { return }
            
            tokens.getToken(for: playerID) { (token, error) in
                guard error == nil else { return }
                guard let token = token else { return }
                self.network.requestHttpHeaders.add(value: token, forKey: "token")
                self.network.makeRequest(toURL: url, withHttpMethod: .get) { (results) in
                    guard let reponse = results.response else { return }
                    if reponse.httpStatusCode == 200 {
                        if let data = results.data {
                            do {
                                let user = try JSONDecoder().decode(User.self, from: data)
                                self.saveUserLocally(user)
                                
                                // TODO: Get token for fetched user
                                
                                completion(user, nil)
                            } catch {
                                completion(nil, error)
                            }
                        }
                    } else {
                        completion(nil, NetworkManager.CustomError.failedToFetchObject)
                    }
                }
            }
        }
        
        public func fetchLocalUser() -> User? {
            if let data = UserDefaults.standard.object(forKey: UserDefaults.Keys.user) as? Data {
                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    return user
                } catch {
                    print(error)
                }
            }
            return nil
        }
        
        public func save(_ user: User, completion: @escaping ((_ success: Bool, _ error: Error?) -> ()) = { _,_ in }) {
            guard let url = URL(string: "\(rootURL)/users") else { return }
            
            network.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
            network.httpBodyParameters.add(value: user.playerID, forKey: "playerID")
            network.httpBodyParameters.add(value: user.displayName, forKey: "displayName")
            network.httpBodyParameters.add(value: user.sessions, forKey: "sessions")
            
            network.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
                guard let response = results.response else { return }
                if response.httpStatusCode == 201 {
                    if let data = results.data {
                        do {
                            let postData = try JSONDecoder().decode(NetworkManager.PostData.self, from: data)
                            let token = postData.token
                            let user = postData.user
                            
                            self.tokens.saveTokenLocally(token)
                            self.saveUserLocally(user)
                            
                            completion(true, nil)
                        } catch {
                            completion(false, error)
                        }
                    }
                } else {
                    completion(false, NetworkManager.CustomError.failedToSaveObject)
                }
            }
        }
        
        public func update(_ user: User, completion: @escaping ((_ success: Bool, _ error: Error?) -> ()) = { _,_ in }) {
            guard let url = URL(string: "\(rootURL)/users/\(user.playerID)") else { return }
            
            tokens.getToken(for: user.playerID) { (token, error) in
                guard error == nil else { return }
                guard let token = token else { return }
                self.network.requestHttpHeaders.add(value: token, forKey: "token")
                self.network.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
                self.network.httpBodyParameters.add(value: user.id, forKey: "_id")
                self.network.httpBodyParameters.add(value: user.playerID, forKey: "playerID")
                self.network.httpBodyParameters.add(value: user.displayName, forKey: "displayName")
                self.network.httpBodyParameters.add(value: user.sessions, forKey: "sessions")
                self.network.httpBodyParameters.add(value: user.createDate, forKey: "createDate")
                
                self.network.makeRequest(toURL: url, withHttpMethod: .put) { (results) in
                    guard let response = results.response else { return }
                    if response.httpStatusCode == 200 {
                        if let data = results.data {
                            do {
                                let user = try JSONDecoder().decode(User.self, from: data)
                                self.saveUserLocally(user)
                                
                                completion(true, nil)
                            } catch {
                                completion(false, error)
                            }
                        }
                    } else {
                        completion(false, NetworkManager.CustomError.failedToUpdateObject)
                    }
                }
            }
        }
        
        public func delete(_ user: User, completion: @escaping ((_ success: Bool, _ error: Error?) -> ()) = { _,_ in }) {
            guard let url = URL(string: "\(rootURL)/users/\(user.playerID)") else { return }
            
            tokens.getToken(for: user.playerID) { (token, error) in
                guard error == nil else { return }
                guard let token = token else { return }
                self.network.requestHttpHeaders.add(value: token, forKey: "token")
                self.network.makeRequest(toURL: url, withHttpMethod: .delete) { (results) in
                    guard let reponse = results.response else { return }
                    if reponse.httpStatusCode == 200 {
                       if let data = results.data {
                           do {
                                let isUserDeleted = try JSONDecoder().decode(Bool.self, from: data)
                                if isUserDeleted {
                                    self.saveUserLocally(user)
                                    completion(true, nil)
                                }
                           } catch {
                               completion(false, error)
                           }
                       }
                    } else {
                        completion(false, NetworkManager.CustomError.failedToDeleteObject)
                    }
                }
            }
        }
        
        // MARK: Private Functions
        
        private func saveUserLocally(_ user: User) {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(user) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: UserDefaults.Keys.user)
            }
        }
        
        private func deleteUserLocally(_ user: User) {
            // TODO: Erase user from UserDefaults
        }
    }
    
}

extension DatabaseManager {
    
    struct Tokens {
        private let network = NetworkManager()
        private let rootURL = "https://ellerbe-creek.herokuapp.com/api"
        
        func updateToken(for playerID: String, completion: @escaping ((NetworkManager.Token?, Error?) -> ()) = { _,_ in }) {
            guard let url = URL(string: "\(rootURL)/token/\(playerID)") else { return }
            
            network.makeRequest(toURL: url, withHttpMethod: .get) { (results) in
                guard let response = results.response else { return }
                if response.httpStatusCode == 201 {
                    if let data = results.data {
                        do {
                            let token = try JSONDecoder().decode(NetworkManager.Token.self, from: data)
                            self.saveTokenLocally(token)
                            completion(token, nil)
                        } catch {
                            completion(nil, error)
                        }
                    }
                } else {
                    completion(nil, NetworkManager.CustomError.failedToUpdateToken)
                }
            }
        }
        
        // MARK: Private Functions
        
        fileprivate func saveTokenLocally(_ token: NetworkManager.Token) {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(token) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: UserDefaults.Keys.token)
            }
        }
        
        fileprivate func getToken(for playerID: String, completion: @escaping (String?, Error?) -> ()) {
            if let data = UserDefaults.standard.object(forKey: UserDefaults.Keys.token) as? Data {
                do {
                    let token = try JSONDecoder().decode(NetworkManager.Token.self, from: data)
                    if !token.isExpired() {
                        completion(token.value, nil)
                    } else {
                        updateToken(for: playerID) { (token, error) in
                            if let token = token {
                                completion(token.value, nil)
                            } else if let error = error {
                                completion(nil, error)
                            }
                        }
                    }
                } catch {
                    completion(nil, error)
                }
            } else {
                updateToken(for: playerID) { (token, error) in
                    if let token = token {
                        completion(token.value, nil)
                    } else if let error = error {
                        completion(nil, error)
                    }
                }
            }
        }
        
    }
    
}
