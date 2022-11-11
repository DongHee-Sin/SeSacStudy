//
//  EnterEmailViewModel.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/12.
//

import Foundation

import RxSwift
import RxCocoa


final class EnterEmailViewModel: CommonViewModel {
    
    struct Input {
        let buttonTap: ControlEvent<Void>
        let email: ControlProperty<String?>
    }
    
    struct Output {
        let buttonTap: ControlEvent<Void>
        let email: ControlProperty<String>
        let validation: Observable<Bool>
    }
    
    
    func transform(input: Input) -> Output {
        
        let text = input.email.orEmpty
        
        let validation = text.withUnretained(self).map { (vm, text) in
            vm.isValidEmail(value: text)
        }
        
        return Output(buttonTap: input.buttonTap, email: text, validation: validation)
    }
    
    
    func isValidEmail(value: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return value.range(of: emailRegex, options: [.regularExpression]) != nil
    }
    
}
