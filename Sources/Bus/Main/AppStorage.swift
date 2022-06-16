//
//  AppStorage.swift
//  MosmetroNew
//
//  Created by Гусейн on 30.07.2021.
//  Copyright © 2021 Гусейн Римиханов. All rights reserved.
//

import Foundation

@propertyWrapper
struct AppData<T> {
    
    private let key: String
    
    private let defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            // Read value from UserDefaults
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            // Set value to UserDefaults
            UserDefaults.standard.set(newValue, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
}
