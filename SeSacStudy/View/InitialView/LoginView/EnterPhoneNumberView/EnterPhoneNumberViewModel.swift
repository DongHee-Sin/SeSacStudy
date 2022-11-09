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
    
    private let telephoneNumRegex = "^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$"
    
    
    
    
    func convertPhoneNumberToKoreaFormat(_ num: String) -> String {
        var result = num
        result.removeFirst()
        result = "+82 " + result
        return result
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
        let buttonTap: ControlEvent<Void>
    }


    func transform(input: Input) -> Output {
        let text = input.phoneNumberText.orEmpty
        
        let validation = text.withUnretained(self)
            .map { (vc, text) in
                text.range(of: vc.telephoneNumRegex, options: [.regularExpression]) != nil
            }
        
        let isTextEntered = text.map { $0.count >= 1 }
        
        return Output(phoneNumberValidatoin: validation, isTextEntered: isTextEntered, buttonTap: input.buttonTap)
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
