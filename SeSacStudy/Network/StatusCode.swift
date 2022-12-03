//
//  StatusCode.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/12/03.
//

import Foundation


enum StatusCode {
    
    enum Common: Int, Error {
        case success = 200
        case firebaseTokenError = 401
        case invalidUser = 406
        case serverError = 500
        case clientError = 501
        
        var message: String {
            switch self {
            case .success:
                return "성공"
            case .firebaseTokenError:
                return "토큰 만료"
            case .serverError, .clientError:
                return "에러가 발생했습니다."
            case .invalidUser:
                return "미가입 회원입니다."
            }
        }
    }
}
