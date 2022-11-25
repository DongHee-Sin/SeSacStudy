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


final class HomeViewModel {
    
    // MARK: - Propertys
    let queueStatus = PublishRelay<QueueStatus>()
    
    let matchStatus = BehaviorRelay<MatchStatus>(value: .normal)
    
    lazy var location = BehaviorRelay<CLLocationCoordinate2D>(value: sesacLocation)
    
    let sesacLocation = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
}
