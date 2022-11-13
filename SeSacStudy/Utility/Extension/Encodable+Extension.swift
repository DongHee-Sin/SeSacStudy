//
//  Encodable+Extension.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/13.
//

import Foundation


enum EncodeError: Error {
    case encodeError
}


extension Encodable {
    
    func encode() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw EncodeError.encodeError
        }
        
        return dictionary
    }
    
}
