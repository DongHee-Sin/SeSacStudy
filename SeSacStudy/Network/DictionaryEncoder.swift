//
//  DictionaryEncoder.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/12/02.
//

import Foundation


final class DictionaryEncoder {
    static let shared = DictionaryEncoder()
    private init() {}
    
    private let encoder = JSONEncoder()
    
    func encode(_ value: Encodable) throws -> [String: Any] {
        let data = try encoder.encode(value)
        return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
    }
}
