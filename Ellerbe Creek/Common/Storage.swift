//
//  Storage.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/4/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import Foundation

public struct StorageKey: RawRepresentable {
    public var rawValue: String
    public init(rawValue value: String) {
        self.init(value)
    }
    
    public init(_ value: String) {
        self.rawValue = value
    }
}

extension StorageKey {
    static let username = StorageKey("username")
    static let currentPreserve = StorageKey("currentPreserve")
}

struct Storage {
    
    func get(key: StorageKey) -> String? {
        return UserDefaults.standard.object(forKey: key.rawValue) as? String ?? nil
    }
    
    func get<T>(key: StorageKey, defaultValue: T) -> T {
        return UserDefaults.standard.object(forKey: key.rawValue) as? T ?? defaultValue
    }
    
    func set(value: Any?, forKey key: StorageKey) {
        if value == nil {
            return UserDefaults.standard.removeObject(forKey: key.rawValue)
        }
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
}

protocol KeyValueStorable {
    var storage: Storage { get }
}

