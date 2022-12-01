//
//  TextViewLine.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/12/01.
//

import Foundation


enum TextViewLine: Int {
    case one = 1
    case two
    case moreThanThree
    
    var height: CGFloat {
        return CGFloat(24 * self.rawValue)
    }
}
