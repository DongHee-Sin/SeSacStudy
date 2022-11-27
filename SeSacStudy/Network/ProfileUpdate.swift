//
//  ProfileUpdate.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/27.
//

import Foundation


struct ProfileUpdate {
    
    let uid: String
    let nick: String
    let reputation: [Int]
    let reviews: [String]
    
    var isExpand: Bool = true
}
