//
//  EnterBirthDayViewModel.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/11.
//

import Foundation

import RxSwift
import RxCocoa


final class EnterBirthDayViewModel {
    
    // MARK: - Propertys
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = "YYYY-MM-DD'T'HH:mm:ss.SSSZ"
    }
    
    private let calendar = Calendar.current
    
    
    
    
    // MARK: - Methods
    func convertToServerFormat(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    
    func convertToDateComponents(_ date: Date) -> DateComponents {
        return calendar.dateComponents([.year, .month, .day], from: date)
    }
    
    
    private func calcValidation(_ date: Date) -> Bool {
        let currentDay = convertToDateComponents(Date())
        let birthDay = convertToDateComponents(date)
        
        let year = currentDay.year! - birthDay.year!
        
        if year > 17 {
            return true
        }
        if year < 17 {
            return false
        }
        

        let month = currentDay.month! - birthDay.month!
        
        if month > 0 {
            return true
        }
        if month < 0 {
            return false
        }
        
        
        let day = currentDay.day! - birthDay.day!
        
        return day >= 0 ? true : false
    }
    
}




extension EnterBirthDayViewModel: CommonViewModel {
    
    struct Input {
        let buttonTap: ControlEvent<Void>
        let birthday: ControlProperty<Date>
    }
    
    struct Output {
        let buttonTap: ControlEvent<Void>
        let birthday: ControlProperty<Date>
        let validation: Observable<Bool>
    }
    
    
    func transform(input: Input) -> Output {
        let validation = input.birthday
            .withUnretained(self)
            .map { (vc, date) in
                return vc.calcValidation(date)
            }
        
        return Output(buttonTap: input.buttonTap, birthday: input.birthday, validation: validation)
    }
    
}
