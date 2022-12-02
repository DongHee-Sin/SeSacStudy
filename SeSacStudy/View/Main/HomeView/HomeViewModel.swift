//
//  HomeViewModel.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/16.
//

import Foundation

import CoreLocation
import RxSwift
import RxCocoa


enum MatchStatus {
    case normal
    case waitingMatch
    case matched
}


/// ⭐️ 반드시 개선!!! 해라 !!! 제발!!!!
/// 뷰모델이 하는일이 없다.
/// 역할 분리좀 제발..
final class HomeViewModel {
    
    // MARK: - Propertys
    let queueStatus = PublishRelay<QueueStatus>()
    
    let matchStatus = BehaviorRelay<MatchStatus>(value: .normal)
    
    lazy var location = BehaviorRelay<CLLocationCoordinate2D>(value: DataStorage.shared.userLocation)
}
