//
//  FirebaseAuthManager.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/09.
//

import Foundation

import FirebaseAuth


final class FirebaseAuthManager {
    
    private init() {}
    
    static let share = FirebaseAuthManager()
    
    private var recentlyUsedNumber = ""
    
    
    
    
    // MARK: - Methods
    func requestAuthNumber(phoneNumber: String? = nil, handler: @escaping (Result<String, Error>) -> Void) {
        if let phoneNumber {
            recentlyUsedNumber = phoneNumber
        }
        
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneNumber ?? recentlyUsedNumber, uiDelegate: nil) { (verificationID, error) in
                if let error {
                    handler(Result.failure(error))
                    return
                }
                
                if let id = verificationID {
                    handler(Result.success(id))
                }
            }
    }
    
    
    func signIn(id: String, code: String, handler: @escaping (Result<AuthDataResult, Error>) -> Void) {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: id,
            verificationCode: code
        )
        
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error {
                handler(Result.failure(error))
                return
            }
            
            if let authResult {
                handler(Result.success(authResult))
            }
        }
    }
    
}
