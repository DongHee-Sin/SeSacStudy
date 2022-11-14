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
        let buttonTap: ControlEvent<Void>
        let manButtonTap: ControlEvent<Void>
        let womanButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let buttonTap: Driver<Void>
        let manButtonTap: ControlEvent<Void>
        let womanButtonTap: ControlEvent<Void>
    }
    
    
    func transform(input: Input) -> Output {
        let buttonTap: Driver<Void> = input.buttonTap.asDriver().throttle(.seconds(3), latest: false)
        
        return Output(buttonTap: buttonTap, manButtonTap: input.manButtonTap, womanButtonTap: input.womanButtonTap)
    }
    
}
