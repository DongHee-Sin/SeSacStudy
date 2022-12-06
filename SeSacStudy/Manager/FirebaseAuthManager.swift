//
//  FirebaseAuthManager.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/09.
//

import Foundation

import FirebaseAuth
import FirebaseMessaging


final class FirebaseAuthManager {
    private init() {}
    static let share = FirebaseAuthManager()
    
    
    // MARK: - Propertys
    private var recentlyUsedNumber = "" {
        didSet {
            let number = recentlyUsedNumber.components(separatedBy: [" ", "-"]).joined()
            UserDefaultManager.shared.phoneNumber = number
        }
    }
    
    
    
    
    // MARK: - Methods
    func requestAuthNumber(phoneNumber: String? = nil, handler: @escaping (Result<String, Error>) -> Void) {
        
        guard NetworkMonitor.shared.isConnected else {
            handler(.failure(NetworkError.notConnected))
            return
        }
        
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
        
        guard NetworkMonitor.shared.isConnected else {
            handler(.failure(NetworkError.notConnected))
            return
        }
        
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
    
    
    func fetchIDToken(handler: @escaping (Result<String, Error>) -> Void) {
        
        guard NetworkMonitor.shared.isConnected else {
            handler(.failure(NetworkError.notConnected))
            return
        }
        
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                handler(.failure(error))
                return
            }
            
            if let idToken {
                UserDefaultManager.shared.idToken = idToken
                handler(.success(idToken))
            }
        }
    }
    
    
    /// FCM 토큰을 갱신하는 코드인지 확인 필요
    /// 갱신되는게 맞다면 따로 저장할 필요 없음 => 토큰 갱신을 모니터링하는 메서드에서 처리되고 있음
    func fetchFCMToken(handler: @escaping (Result<String, Error>) -> Void) {
        
        guard NetworkMonitor.shared.isConnected else {
            handler(.failure(NetworkError.notConnected))
            return
        }
        
        Messaging.messaging().token { fcmToken, error in
            if let error = error {
                handler(.failure(error))
                return
            }
            
            if let fcmToken {
                UserDefaultManager.shared.fcmToken = fcmToken
                handler(.success(fcmToken))
            }
        }
    }
}
