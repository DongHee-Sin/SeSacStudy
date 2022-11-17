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
    
    
    
    
    // MARK: - Methods
    
}




//extension HomeViewModel: CommonViewModel {
//    
//    struct Input {
//        let gpsButtonTap: ControlEvent<Void>
//        let floatingButtonTap: ControlProperty<String?>
//    }
//    
//    struct Output {
//        let gpsButtonTap: ControlEvent<Void>
//    }
//    
//    
//    func transform(input: Input) -> Output {
//        let floatingButtonStatus = input.floatingButtonTap.map { return matchStatus }
//    }
//}
