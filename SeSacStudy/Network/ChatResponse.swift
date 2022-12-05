//
//  ChatResponse.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/12/05.
//

import Foundation


struct ChatList: Codable {
    let payload: [ChatResponse]
}


struct ChatResponse: Codable {
    let id, to, from, chat: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case to, from, chat, createdAt
    }
}
