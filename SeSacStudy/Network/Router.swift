//
//  Router.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/09.
//

import Foundation

import Alamofire


/// Path별로 구분해두면 좋을 것 같다.
enum Router: URLRequestConvertible {
    case login
    case signUp(body: SignUp)
    case mypage(body: MyPage)
    case withdraw
    case queueStatus
    case queueSearch
    case requestSearch(list: [String])
    case cancelRequestSearch
    case requestStudy(uid: String)
    case acceptStudy(uid: String)
    
    
    private var baseURL: URL {
        return URL(string: "http://api.sesac.co.kr:1210")!
    }
    
    
    private var method: HTTPMethod {
        switch self {
        case .login, .queueStatus:
            return .get
        case .signUp, .withdraw, .queueSearch, .requestSearch, .requestStudy, .acceptStudy:
            return .post
        case .mypage:
            return .put
        case .cancelRequestSearch:
            return .delete
        }
    }
    
    
    /// ULR 주소도 따로 관리하면 좋다.
    private var path: String {
        switch self {
        case .login, .signUp:
            return "/v1/user"
        case .mypage: return "/v1/user/mypage"
        case .withdraw: return "/v1/user/withdraw"
        case .queueStatus: return "/v1/queue/myQueueState"
        case .queueSearch: return "/v1/queue/search"
        case .requestSearch, .cancelRequestSearch:
            return "/v1/queue"
        case .requestStudy: return "/v1/queue/studyrequest"
        case .acceptStudy: return "/v1/queue/studyaccept"
        }
    }
    
    
    private var header: HTTPHeaders {
        switch self {
        case .login, .withdraw, .queueStatus, .queueSearch, .cancelRequestSearch:
            return [
                "idtoken": UserDefaultManager.shared.idToken,
            ]
        case .signUp, .mypage, .requestSearch, .requestStudy, .acceptStudy:
            return [
                "idtoken": UserDefaultManager.shared.idToken,
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        }
    }
    
    
    /// body를 딕셔너리로 변환하는 메서드를 사용하자
    /// 모델의 프로퍼티가 변경되었어도 바로 적용될 수 있도록, 코드 관리하기 좋게
    private var param: Parameters? {
        switch self {
        case .login, .withdraw, .queueStatus, .cancelRequestSearch:
            return nil
        case .signUp(let body):
            return try? DictionaryEncoder.shared.encode(body)
        case .mypage(let body):
            return try? DictionaryEncoder.shared.encode(body)
        case .queueSearch:
            return [
                "lat": DataStorage.shared.userLocation.latitude,
                "long": DataStorage.shared.userLocation.longitude
            ]
        case .requestSearch(let list):
            return [
                "lat": DataStorage.shared.userLocation.latitude,
                "long": DataStorage.shared.userLocation.longitude,
                "studylist": list
            ]
        case .requestStudy(let uid), .acceptStudy(let uid):
            return ["otheruid": uid]
        }
    }
    
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        request.headers = header
        
        if let param {
            let encoder = URLEncoding(arrayEncoding: .noBrackets)
            return try encoder.encode(request, with: param)
        }
        
        return request
    }
}
