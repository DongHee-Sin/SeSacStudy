//
//  EnterNicknameViewModel.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/11.
//

import Foundation

import RxSwift
import RxCocoa


final class EnterNicknameViewModel {
    
    struct Input {
        let buttonTap: ControlEvent<Void>
        let nickname: ControlProperty<String?>
    }
    
    struct Output {
        let buttonTap: ControlEvent<Void>
        let nickname: ControlProperty<String>
        let validation: Observable<Bool>
    }
    
    
    func transform(input: Input) -> Output {
        let text = input.nickname.orEmpty
        
        let validation = text.map { $0.count >= 1 }
        
        return Output(buttonTap: input.buttonTap, nickname: text, validation: validation)
    }
    
}
