//
//  Router.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/09.
//

import Foundation

import Alamofire


enum Router: URLRequestConvertible {
    case login
    // case signUP (필요한 데이터는 연관값으로 전달)
    
    
    var baseURL: URL {
        return URL(string: "http://api.sesac.co.kr:1207\(version)")!
    }
    
    
    private var version: String {
        return "/v1"
    }
    
    
    var method: HTTPMethod {
        switch self {
        case .login: return .get
        }
    }
    
    
    var path: String {
        switch self {
        case .login: return "/user"
        }
    }
    
    
    var header: HTTPHeaders {
        return ["idtoken": UserDefaultManager.shared.idToken]
    }
    
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        request.headers = header
        
        return request
    }
}
