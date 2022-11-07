//
//  UserDefaultManager.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/07.
//

import Foundation


@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: self.key) as? T ?? defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: self.key) }
    }
}


final class UserDefaultManager {
    
    static let shared = UserDefaultManager()
    
    private init() {}
    
    
    
    
    // MARK: - Propertys
    @UserDefault(key: "isInitialLaunch", defaultValue: true)
    var isInitialLaunch: Bool
    
    
    
    
    // MARK: - Method
    func resetAllData() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
}
