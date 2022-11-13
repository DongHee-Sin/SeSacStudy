//
//  SignUpModel.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/13.
//

import Foundation


final class SignUpModel {
    
    private init() {}
    
    static let shared = SignUpModel()
    
    
    
    
    // MARK: - Propertys
    private var signUp = SignUp(phoneNumber: UserDefaultManager.shared.phoneNumber,
                        FCMtoken: UserDefaultManager.shared.fcmToken,
                        nick: "",
                        birth: "",
                        email: "",
                        gender: 2) {
        didSet {
            print("SignUp Value Changed: \(signUp)")
        }
    }
    
    
    var model: SignUp { return signUp }
    
    
    
    
    // MARK: - Methods
    func add(nickname: String) {
        signUp.nick = nickname
    }
    
    
    func add(birtyDay: String) {
        signUp.birth = birtyDay
    }
    
    
    func add(email: String) {
        signUp.email = email
    }
    
    
    func add(gender: Gender) {
        signUp.gender = gender.rawValue
    }
}
