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
    
    /// 값이 변경되면
    /// 텍스트를 기반으로, scrollEnabled 여부를 customView로 전달
    /// 
}




extension ChattingViewModel: CommonViewModel {
    
    struct Input {
        let text: ControlProperty<String?>
        let beginEditing: ControlEvent<Void>
        let endEditing: ControlEvent<Void>
    }
    
    struct Output {
        let line: Observable<TextViewLine>
        let beginEditing: ControlEvent<Void>
        let endEditing: ControlEvent<Void>
    }
    
    
    func transform(input: Input) -> Output {
        let scrollEnabled = input.text.orEmpty.map {
            let arr = $0.components(separatedBy: "\n")
            let count = arr.count
            let line = TextViewLine(rawValue: count) ?? .moreThanThree
            return line
        }
        
        return Output(line: scrollEnabled, beginEditing: input.beginEditing, endEditing: input.endEditing)
    }
}
