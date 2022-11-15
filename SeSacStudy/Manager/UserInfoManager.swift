//
//  UserInfoManager.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/16.
//

import UIKit


final class UserInfoManager {
    
    private init() {}
    
    static let shared = UserInfoManager()
    
    
    
    
    // MARK: - Propertys
    private(set) var login: Login!
    
    var sesacImage: UIImage {
        return UIImage(named: "sesac_background_\(login.background+1)") ?? UIImage()
    }
    
    
    
    
    
    
    // MARK: - Methods
    func updateInfo(info: Login) {
        login = info
    }
}
