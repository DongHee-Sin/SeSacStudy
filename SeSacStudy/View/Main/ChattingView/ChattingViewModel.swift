//
//  ChattingViewModel.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/12/01.
//

import Foundation

import RxSwift
import RxCocoa


final class ChattingViewModel {
    private let dateFormatter = DateFormatter()
    
    let matchStatus = BehaviorRelay<MatchStatus>(value: .matched)
}




extension ChattingViewModel: CommonViewModel {
    
    struct Input {
        let text: ControlProperty<String?>
        let beginEditing: ControlEvent<Void>
        let endEditing: ControlEvent<Void>
        let reportTap: ControlEvent<Void>
        let cancelTap: ControlEvent<Void>
        let reviewTap: ControlEvent<Void>
    }
    
    struct Output {
        let line: Observable<TextViewLine>
        let sendButtonEnable: Observable<Bool>
        let beginEditing: ControlEvent<Void>
        let endEditing: ControlEvent<Void>
        let reportTap: ControlEvent<Void>
        let cancelTap: ControlEvent<Void>
        let reviewTap: ControlEvent<Void>
    }
    
    
    func transform(input: Input) -> Output {
        let text = input.text.orEmpty
        
        let scrollEnabled = text.map {
            let arr = $0.components(separatedBy: "\n")
            let count = arr.count
            let line = TextViewLine(rawValue: count) ?? .moreThanThree
            return line
        }
        
        let sendButtonEnable = text.map {
            if $0 != Placeholder.chatting.rawValue && $0.count >= 1 {
                return true
            }else {
                return false
            }
        }
        
        return Output(line: scrollEnabled, sendButtonEnable: sendButtonEnable, beginEditing: input.beginEditing, endEditing: input.endEditing, reportTap: input.reportTap, cancelTap: input.cancelTap, reviewTap: input.reviewTap)
    }
}
