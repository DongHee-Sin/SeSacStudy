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
    case SignUp(body: SignUp)
    
    
    var baseURL: URL {
        return URL(string: "http://api.sesac.co.kr:1207")!
    }
    
    
    var method: HTTPMethod {
        switch self {
        case .login: return .get
        case .SignUp: return .post
        }
    }
    
    
    var path: String {
        switch self {
        case .login: return "/v1/user"
        case .SignUp: return "/v1/user"
        }
    }
    
    
    var header: HTTPHeaders {
        switch self {
        case .login:
            return [
                "idtoken": UserDefaultManager.shared.idToken,
            ]
        case .SignUp:
            return [
                "idtoken": UserDefaultManager.shared.idToken,
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        }
    }
    
    
    var param: Parameters? {
        switch self {
        case .login: return nil
        case .SignUp(let body):
            return [
                "phoneNumber": body.phoneNumber,
                "FCMtoken": body.FCMtoken,
                "nick": body.nick,
                "birth": body.birth,
                "email": body.email,
                "gender": body.gender
            ]
        }
    }
    
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        request.headers = header
    
        if let param {
            return try URLEncoding.default.encode(request, with: param)
        }

        return request
    }
}
