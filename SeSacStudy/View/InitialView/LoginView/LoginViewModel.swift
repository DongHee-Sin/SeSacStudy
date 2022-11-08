//
//  LoginViewModel.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/08.
//

import Foundation

import RxSwift
import RxCocoa


final class LoginViewModel {
    
    let phoneNumber = PublishRelay<String>()
    
}




extension LoginViewModel: CommonViewModel {

    struct Input {
        let phoneNumberText: ControlProperty<String?>
        let buttonTap: ControlEvent<Void>
    }

    struct Output {
        let phoneNumberText: ControlProperty<String>
        let buttonTap: ControlEvent<Void>
    }


    func transfrom(input: Input) -> Output {
        let text = input.phoneNumberText.orEmpty
        
        return Output(phoneNumberText: text, buttonTap: input.buttonTap)
    }
}
