//
//  QueueSearchResult.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/17.
//

import Foundation


struct QueueSearchResult: Codable {
    var fromQueueDB: [User]            // 스터디를 찾는 다른 사용자 목록
    var fromQueueDBRequested: [User]   // 나에게 스터디를 요청한 다른 사용자의 목록
    var fromRecommend: [String]
}


struct User: Codable {
    var uid: String
    var nick: String
    var lat: Double
    var long: Double
    var reputation: [Int]
    var studylist: [String]
    var reviews: [String]
    var gender: Int
    var type: Int
    var sesac: Int
    var background: Int
}
