//
//  MyPage.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/16.
//

import Foundation


struct MyPage: Codable {
    
    init(login: Login) {
        searchable = login.searchable
        ageMin = login.ageMin
        ageMax = login.ageMax
        gender = login.gender
        study = login.study
    }
    
    
    var searchable: Int
    var ageMin: Int
    var ageMax: Int
    var gender: Int
    var study: String
    
}
