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
    let timerSecond = PublishRelay<Int>()
    
    var time: Int = 60 {
        didSet {
            timerSecond.accept(time)
        }
    }
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
        let count = text.map { $0.count }
        
        let validation = count.map { $0 == 6 }
        let isTextEntered = count.map { $0 >= 1 }
        
        return Output(authNumberValidatoin: validation, isTextEntered: isTextEntered, resendTap: input.resendTap, verifyTap: input.verifyTap)
    }
}
