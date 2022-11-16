//
//  QueueStatus.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/16.
//

import Foundation


struct QueueStatus: Codable {
    var dodged: Int
    var matched: Int
    var reviewed: Int
    var matchedNick: String
    var matchedUid: String?
}
