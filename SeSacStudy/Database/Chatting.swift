//
//  Chatting.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/12/05.
//

import Foundation

import RealmSwift


class Chatting: Object {
    @Persisted var uid: String
    @Persisted var text: String
    @Persisted var date: Date
    
    @Persisted(primaryKey: true) var objectID: ObjectId
    
    convenience init(uid: String, text: String, date: Date) {
        self.init()
        self.uid = uid
        self.text = text
        self.date = date
    }
}
