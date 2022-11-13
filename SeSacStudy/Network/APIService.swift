//
//  APIService.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/09.
//

import Foundation

import Alamofire


final class APIService {
    
    private init() {}
    
    static let share = APIService()
    
    
    func request<T: Decodable>(type: T.Type, router: Router, completion: @escaping (T?, Error?, Int?) -> Void) {
        
        AF.request(router)
            .validate(statusCode: 200...501)
            .responseDecodable(of: type) { response in
                switch response.result {
                case .success(let result): completion(result, nil, response.response?.statusCode)
                case .failure(let error): completion(nil, error, response.response?.statusCode)
                }
            }
    }
    
    
    func request(router: Router, completion: @escaping (Error?, Int?) -> Void) {
        
//        AF.request(router)
//            .validate(statusCode: 200...200)
//            .response { response in
//                switch response.result {
//                case .success(_): completion(nil, response.response?.statusCode)
//                case .failure(let error): completion(error, response.response?.statusCode)
//                }
//            }
        AF.request(router)
            .validate(statusCode: 200...501)
            .response { response in
                switch response.result {
                case .success(_): completion(nil, response.response?.statusCode)
                case .failure(let error): completion(error, response.response?.statusCode)
                }
            }
        
    }
    
}
