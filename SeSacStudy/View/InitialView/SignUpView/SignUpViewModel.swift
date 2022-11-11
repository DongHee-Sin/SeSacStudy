//
//  SignUpViewModel.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/10.
//

import Foundation

import RxSwift
import RxCocoa


/// Encodable 객체 미리 생성
/// VM의 프로퍼티 값이 변경될 때마다, Encodable 인스턴스의 값 변경
/// 회원가입 API에 해당 인스턴스 전달
final class SignUpViewModel {
    
    // MARK: - Propertys
    var signUp = SignUp(phoneNumber: UserDefaultManager.shared.phoneNumber,
                        FCMtoken: UserDefaultManager.shared.fcmToken,
                        nick: "",
                        birth: "",
                        email: "",
                        gender: 2) {
        didSet {
            print("SignUp Value Changed: \(signUp)")
        }
    }
    
    
    
    
    // MARK: - Methods
    
    
}
