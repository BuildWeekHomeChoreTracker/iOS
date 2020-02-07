//
//  UserDefaultsWrapper.swift
//  HomeChoresTracker
//
//  Created by Kenny on 2/6/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
/**
 Holds keys and methods for manipulating UserDefaults
 */
extension UserDefaults {
    public enum Keys {
        static let lastLoggedInUser = "lastLoggedInUser"
    }

    /// Stores the last logged in user
    var lastLoggedInUser: String {
        set {
            set(newValue, forKey: Keys.lastLoggedInUser)
        }
        get {
            let loggedInKey = string(forKey: Keys.lastLoggedInUser)
            return loggedInKey ?? ""
        }
    }
}
