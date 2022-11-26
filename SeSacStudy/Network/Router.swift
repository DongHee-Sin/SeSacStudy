//
//  Router.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/09.
//

import Foundation

import Alamofire
import CoreLocation


enum Router: URLRequestConvertible {
    case login
    case signUp(body: SignUp)
    case mypage(body: MyPage)
    case withdraw
    case queueStatus
    case queueSearch(location: CLLocationCoordinate2D)
    case requestSearch(location: CLLocationCoordinate2D, list: [String])
    case cancelRequestSearch
    
    
    var baseURL: URL {
        return URL(string: "http://api.sesac.co.kr:1210")!
    }
    
    
    var method: HTTPMethod {
        switch self {
        case .login, .queueStatus:
            return .get
        case .signUp, .withdraw, .queueSearch, .requestSearch:
            return .post
        case .mypage:
            return .put
        case .cancelRequestSearch:
            return .delete
        }
    }
    
    
    var path: String {
        switch self {
        case .login, .signUp:
            return "/v1/user"
        case .mypage: return "/v1/user/mypage"
        case .withdraw: return "/v1/user/withdraw"
        case .queueStatus: return "/v1/queue/myQueueState"
        case .queueSearch: return "/v1/queue/search"
        case .requestSearch, .cancelRequestSearch:
            return "/v1/queue"
        }
    }
    
    
    var header: HTTPHeaders {
        switch self {
        case .login, .withdraw, .queueStatus, .queueSearch, .cancelRequestSearch:
            return [
                "idtoken": UserDefaultManager.shared.idToken,
            ]
        case .signUp, .mypage, .requestSearch:
            return [
                "idtoken": UserDefaultManager.shared.idToken,
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        }
    }
    
    
    var param: Parameters? {
        switch self {
        case .login, .withdraw, .queueStatus, .cancelRequestSearch:
            return nil
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
        case .queueSearch(let location):
            return [
                "lat": location.latitude,
                "long": location.longitude
            ]
        case .requestSearch(let location, let list):
            return [
                "lat": location.latitude,
                "long": location.longitude,
                "studylist": "\(list)"
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
