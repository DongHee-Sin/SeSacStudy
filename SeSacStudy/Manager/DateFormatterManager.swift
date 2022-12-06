//
//  DateFormatterManager.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/16.
//

import Foundation


final class DateFormatterManager {
    private init() {}
    static let shared = DateFormatterManager()
    
    
    // MARK: - Propertys
    private let dateFormatter = DateFormatter().then {
        $0.locale = Locale(identifier: "ko_KR")
        $0.timeZone = TimeZone(identifier: "Asia/Seoul")
        $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    }
    
    
    
    
    // MARK: - Methods
    func date(from string: String) -> Date? {
        return dateFormatter.date(from: string)
    }
    
    
    func string(from date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}
