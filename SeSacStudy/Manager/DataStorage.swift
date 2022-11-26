//
//  UserInfoManager.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/16.
//

import UIKit

import CoreLocation


final class DataStorage {
    
    private init() {}
    
    static let shared = DataStorage()
    
    
    
    
    // MARK: - Propertys
    private(set) var login: Login!
    private(set) var SearchResult: QueueSearchResult! {
        didSet {
            SearchResult.fromQueueDB.forEach {
                print("\($0.nick) \($0.studylist) \($0.type)")
            }
            
            SearchResult.fromQueueDBRequested.forEach {
                print("⭐️ \($0.nick) \($0.studylist)")
            }
        }
    }
    
    var userLocation = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
    
    var sesacImage: UIImage {
        return UIImage(named: "sesac_background_\(login.background+1)") ?? UIImage()
    }
    
    var userStudyList: [String] {
        var result: [String] = []
        
        SearchResult.fromQueueDB.forEach {
            result.append(contentsOf: $0.studylist)
        }
        
        SearchResult.fromQueueDBRequested.forEach {
            result.append(contentsOf: $0.studylist)
        }
        
        return result
    }
    
    
    
    
    
    
    // MARK: - Methods
    func updateInfo(info: Login) {
        login = info
    }
    
    func updateSearchResult(info: QueueSearchResult) {
        SearchResult = info
    }
}
