//
//  ChattingViewModel.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/12/01.
//

import Foundation

import RxSwift
import RxCocoa


private final class ChattingDateFormatter: DateFormatter {
    convenience init(isTodyFormatter: Bool) {
        self.init()
        self.amSymbol = "오전"
        self.pmSymbol = "오후"
        self.dateFormat = isTodyFormatter ? "a hh:mm" : "MM/dd a hh:mm"
    }
}


final class ChattingViewModel {
    
    // MARK: - Propertys
    private lazy var todayFormatter = ChattingDateFormatter(isTodyFormatter: true)
    
    private lazy var notTodayFormatter = ChattingDateFormatter(isTodyFormatter: false)
    
    private let calendar = {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? TimeZone.current
        return calendar
    }()
    
    let matchStatus = BehaviorRelay<MatchStatus>(value: .matched)
    
    
    
    
    // MARK: - Methods
    private func calcIsToday(_ date: Date) -> Bool {
        let today = Date()
        guard let result = calendar.dateComponents([.day], from: date, to: today).day else { return false }
        return result < 1 ? true : false
    }
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
