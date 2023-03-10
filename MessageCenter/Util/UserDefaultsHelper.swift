//
//  UserDefaultsHelper.swift
//  MessageCenter
//
//  Created by Alan Taichung on 2023/3/10.
//

import Foundation

// MARK: - UserDefaults
class UserDefaultsHelper {
    
    enum Keys: String {
        case sessionToken = "session-token"
        case pushToken = "push-token"
        case loginName = "logged_in_name"
    }
    
    static let defaults = UserDefaults.standard
        
    static func set(value: String, forKey key: Keys) {
        defaults.setValue(value, forKey: key.rawValue)
    }
    
    static func get(forKey key: Keys) -> String? {
        defaults.value(forKey: key.rawValue) as? String
    }
    
    static func remove(fokKey key: Keys) {
        defaults.removeObject(forKey: key.rawValue)
    }
    
}
