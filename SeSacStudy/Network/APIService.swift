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
            .validate(statusCode: 200...200)
            .responseDecodable(of: type) { response in
                switch response.result {
                case .success(let result): completion(result, nil, response.response?.statusCode)
                case .failure(let error): completion(nil, error, response.response?.statusCode)
                }
            }
        
    }
    
}
