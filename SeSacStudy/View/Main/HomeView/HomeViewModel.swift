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
    let matchStatus = PublishRelay<MatchStatus>()
    
    let location = PublishRelay<CLLocationCoordinate2D>()
}
