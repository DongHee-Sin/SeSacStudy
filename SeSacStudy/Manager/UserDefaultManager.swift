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
    
    @UserDefault(key: "idToken", defaultValue: "")
    var idToken: String
    
    
    @UserDefault(key: "fcmToken", defaultValue: "")
    var fcmToken: String
    
    @UserDefault(key: "phoneNumber", defaultValue: "")
    var phoneNumber: String
    
    @UserDefault(key: "matchedUserId", defaultValue: "")
    var matchedUserId: String
    
    @UserDefault(key: "matchedUserNick", defaultValue: "")
    var matchedUserNick: String
    
    
    
    
    // MARK: - Method
    func resetAllData() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
}
