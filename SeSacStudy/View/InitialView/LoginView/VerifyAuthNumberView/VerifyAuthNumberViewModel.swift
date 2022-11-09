//
//  VerifyAuthNumberViewModel.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/09.
//

import Foundation

import RxSwift
import RxCocoa


final class VerifyAuthNumberViewModel {
    
}




extension VerifyAuthNumberViewModel: CommonViewModel {

    struct Input {
        let authNumberText: ControlProperty<String?>
        let resendTap: ControlEvent<Void>
        let verifyTap: ControlEvent<Void>
    }

    struct Output {
        let authNumberValidatoin: Observable<Bool>
        let isTextEntered: Observable<Bool>
        
        let resendTap: ControlEvent<Void>
        let verifyTap: ControlEvent<Void>
    }


    func transform(input: Input) -> Output {
        let text = input.authNumberText.orEmpty
        
        let validation = text.map { $0.count == 6 }
        
        let isTextEntered = text.map { $0.count >= 1 }
        
        return Output(authNumberValidatoin: validation, isTextEntered: isTextEntered, resendTap: input.resendTap, verifyTap: input.verifyTap)
    }
}
