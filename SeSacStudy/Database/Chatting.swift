//
//  Chatting.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/12/05.
//

import Foundation

import RealmSwift


class Chatting: Object {
    @Persisted var to: String
    @Persisted var from: String
    @Persisted var chat: String
    @Persisted var createdAt: Date
    
    @Persisted(primaryKey: true) var objectID: ObjectId
    
    convenience init(to: String, from: String, text: String, date: Date) {
        self.init()
        self.to = to
        self.from = from
        self.chat = text
        self.createdAt = date
    }
}
