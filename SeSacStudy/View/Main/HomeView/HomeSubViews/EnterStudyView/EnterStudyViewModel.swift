//
//  EnterStudyViewModel.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/20.
//

import Foundation

import RxSwift
import RxCocoa


enum StudyEnterStatus {
    case success
    case exceedLimit
    case duplicateStudy
}


final class EnterStudyViewModel {
    
    // MARK: - Propertys
    var recommendList: [String] = []
    
    var userStudyList: [String] = []
    
    let myWishStudyList = BehaviorRelay<[String]>(value: [])
    
    
    
    
    // MARK: - Methods
    private func enterStudyValidation(count: Int) -> Bool {
        return (myWishStudyList.value.count + count) <= 8
    }
    
    
    private func checkDuplicate(list: [String]) -> Bool {
        return Set(list).count == list.count
    }
    
    
    func appendWishStudyList(list: [String]) -> StudyEnterStatus {
        guard enterStudyValidation(count: list.count) else {
            return .exceedLimit
        }
        
        var newValue = myWishStudyList.value
        newValue.append(contentsOf: list)
        
        guard checkDuplicate(list: newValue) else {
            return .duplicateStudy
        }
        
        myWishStudyList.accept(newValue)
        return .success
    }
    
    
    func removeWishStudyList(at index: Int) {
        var newValue = myWishStudyList.value
        newValue.remove(at: index)
        myWishStudyList.accept(newValue)
    }
}
