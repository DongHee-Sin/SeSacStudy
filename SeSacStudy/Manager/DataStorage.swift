//
//  UserInfoManager.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/16.
//

import Foundation

import CoreLocation


final class DataStorage {
    
    private init() {}
    static let shared = DataStorage()
    
    
    struct MatchedUser {
        let id: String
        let nick: String
    }
    
    
    // MARK: - Propertys
    private(set) var login: Login!
    private var SearchResult: QueueSearchResult! {
        didSet {
            SearchResult.fromQueueDB.forEach {
                print("주변새싹 : \($0.nick) \($0.studylist) \($0.type)")
            }
            
            SearchResult.fromQueueDBRequested.forEach {
                print("받은요청 : \($0.nick) \($0.studylist)")
            }
        }
    }
    
    var userLocation = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
    
    var sesacImage: String { "sesac_background_\(login.background+1)" }
    
    var fromQueueDB: [User] { SearchResult.fromQueueDB }
    
    var fromQueueDBRequested: [User] { SearchResult.fromQueueDBRequested }
    
    var userStudyList: [String] {
        var result: [String] = []
        
        fromQueueDB.forEach {
            result.append(contentsOf: $0.studylist)
        }
        
        fromQueueDBRequested.forEach {
            result.append(contentsOf: $0.studylist)
        }
        
        return result
    }
    
    private(set) var matchedUser: MatchedUser? = nil
    
    
    
    
    // MARK: - Methods
    func updateInfo(info: Login) {
        login = info
    }
    
    func updateSearchResult(info: QueueSearchResult) {
        SearchResult = info
    }
    
    func registerMatchedUser(id: String, nick: String) {
        matchedUser = MatchedUser(id: id, nick: nick)
    }
}
