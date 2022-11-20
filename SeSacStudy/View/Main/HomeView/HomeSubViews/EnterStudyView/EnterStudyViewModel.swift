//
//  EnterStudyViewModel.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/20.
//

import Foundation

import RxSwift
import RxCocoa


final class EnterStudyViewModel {
    
    let recommendList = DataStorage.shared.SearchResult.fromRecommend
    
    let userStudyList = DataStorage.shared.userStudyList
    
    let myWishStudyList = BehaviorRelay<[String]>(value: [])
    
}
