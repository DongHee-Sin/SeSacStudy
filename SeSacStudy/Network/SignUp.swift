//
//  SignUp.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/10.
//

import Foundation


enum Gender: Int {
    case woman
    case man
}


struct SignUp: Codable {
    var phoneNumber: String
    var FCMtoken: String
    var nick: String
    var birth: String
    var email: String
    var gender: Int
}
