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
    case signUp(body: SignUp)
    case mypage(body: MyPage)
    
    
    var baseURL: URL {
        return URL(string: "http://api.sesac.co.kr:1207")!
    }
    
    
    var method: HTTPMethod {
        switch self {
        case .login: return .get
        case .signUp: return .post
        case .mypage: return .put
        }
    }
    
    
    var path: String {
        switch self {
        case .login: return "/v1/user"
        case .signUp: return "/v1/user"
        case .mypage: return "/v1/user/mypage"
        }
    }
    
    
    var header: HTTPHeaders {
        switch self {
        case .login:
            return [
                "idtoken": UserDefaultManager.shared.idToken,
            ]
        case .signUp, .mypage:
            return [
                "idtoken": UserDefaultManager.shared.idToken,
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        }
    }
    
    
    var param: Parameters? {
        switch self {
        case .login: return nil
        case .signUp(let body):
            return [
                "phoneNumber": body.phoneNumber,
                "FCMtoken": body.FCMtoken,
                "nick": body.nick,
                "birth": body.birth,
                "email": body.email,
                "gender": body.gender
            ]
        case .mypage(let body):
            return [
                "searchable": body.searchable,
                "ageMin": body.ageMin,
                "ageMax": body.ageMax,
                "gender": body.gender,
                "study": body.study
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
