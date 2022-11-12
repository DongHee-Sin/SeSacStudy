//
//  EnterGenderViewModel.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/12.
//

import Foundation

import RxSwift
import RxCocoa


final class EnterGenderViewModel: CommonViewModel {
    
    let selectedGender = PublishRelay<Gender>()
    
    
    
    struct Input {
        let manButtonTap: ControlEvent<Void>
        let womanButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let manButtonTap: ControlEvent<Void>
        let womanButtonTap: ControlEvent<Void>
    }
    
    
    func transform(input: Input) -> Output {
        return Output(manButtonTap: input.manButtonTap, womanButtonTap: input.womanButtonTap)
    }
    
}
