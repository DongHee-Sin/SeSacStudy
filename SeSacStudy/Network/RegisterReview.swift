//
//  RegisterReview.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/12/16.
//

import Foundation


struct RegisterReview: Codable {
    var otheruid: String
    var reputation: [Int]
    var comment: String
}
