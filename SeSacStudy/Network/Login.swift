//
//  Login.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/09.
//

import Foundation


struct Login: Codable {
    
    var uid: String
    var phoneNumber: String
    var email: String
    var FCMtoken: String
    var nick: String
    var birth: String
    var gender: Int
    var study: String
    var comment: [String]
    var reputation: [Int]
    var sesac: Int
    var sesacCollection: [Int]
    var background: Int
    var backgroundCollection: [Int]
    var purchaseToken: [String]
    var transactionId: [String]
    var reviewedBefore: [String]
    var reportedNum: Int
    var reportedUser: [String]
    var dodgepenalty: Int
    var dodgeNum: Int
    var ageMin: Int
    var ageMax: Int
    var searchable: Int
    var createdAt: String

}
