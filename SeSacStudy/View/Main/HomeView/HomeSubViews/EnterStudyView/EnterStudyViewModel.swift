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
    
    // MARK: - Propertys
    let recommendList = DataStorage.shared.SearchResult.fromRecommend
    
    let userStudyList = DataStorage.shared.userStudyList
    
    let myWishStudyList = BehaviorRelay<[String]>(value: [])
    
    
    
    
    // MARK: - Methods
    func studyEnterValidation(count: Int) -> Bool {
        return (myWishStudyList.value.count + count) <= 8
    }
    
    
    func appendWishStudyList(list: [String]) {
        var newValue = myWishStudyList.value
        newValue.append(contentsOf: list)
        myWishStudyList.accept(newValue)
    }
    
    
    func removeWishStudyList(at index: Int) {
        var newValue = myWishStudyList.value
        newValue.remove(at: index)
        myWishStudyList.accept(newValue)
    }
}
