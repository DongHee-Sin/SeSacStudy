//
//  LoginViewModel.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/08.
//

import Foundation

import RxSwift
import RxCocoa


final class EnterPhoneNumberViewModel {
    
    func convertPhoneNumberToKoreaFormat(_ num: String) -> String {
        var result = num
        result.removeFirst()
        result = "+82 " + result
        return result
    }
    
    
    private func isValidPhoneNumber(_ value: String) -> Bool {
        let telephoneNumRegex = "^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$"
        return value.range(of: telephoneNumRegex, options: [.regularExpression]) != nil
    }
}




extension EnterPhoneNumberViewModel: CommonViewModel {

    struct Input {
        let phoneNumberText: ControlProperty<String?>
        let buttonTap: ControlEvent<Void>
    }

    struct Output {
        let phoneNumberValidatoin: Observable<Bool>
        let isTextEntered: Observable<Bool>
        let buttonTap: Driver<Void>
    }


    func transform(input: Input) -> Output {
        let text = input.phoneNumberText.orEmpty
        
        let buttonTap: Driver<Void> = input.buttonTap.asDriver().throttle(.seconds(3), latest: false)
        
        let validation = text.withUnretained(self)
            .map { (vc, text) in
                vc.isValidPhoneNumber(text)
            }
        
        let isTextEntered = text.map { $0.count >= 1 }
        
        return Output(phoneNumberValidatoin: validation, isTextEntered: isTextEntered, buttonTap: buttonTap)
    }
}




extension EnterPhoneNumberViewModel {
    
    func formatPhoneStyle(_ text: String) -> String {
        let text = text.components(separatedBy: "-").joined()
        
        let count = text.count
        var result: [String] = []
        
        switch count {
        case 0...3: return text
        case 4...6:
            for (index, char) in text.enumerated() {
                if index == 3 {
                    result.append("-")
                }
                result.append(String(char))
            }
        case 7...10:
            for (index, char) in text.enumerated() {
                if index == 3 || index == 6 {
                    result.append("-")
                }
                result.append(String(char))
            }
        case 11:
            for (index, char) in text.enumerated() {
                if index == 3 || index == 7 { result.append("-") }
                result.append(String(char))
            }
        default: break
        }
        
        return result.joined()
    }
    
}
