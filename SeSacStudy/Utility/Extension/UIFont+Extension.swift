//
//  UIFont+Extension.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/07.
//

import UIKit


extension UIFont {
    
    static func customFont(_ style: FontStyle) -> UIFont {
        return UIFont(name: style.weight.rawValue, size: style.size) ?? .systemFont(ofSize: style.size)
    }
    
}
