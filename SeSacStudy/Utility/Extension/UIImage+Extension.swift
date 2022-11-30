//
//  UIImage+Extension.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/30.
//

import UIKit


extension UIImage {
    
    static func backgroundImage(_ value: Int) -> UIImage? {
        return UIImage(named: "sesac_background_\(value + 1)")
    }
    
    
    static func sesacImage(_ value: Int) -> UIImage? {
        return UIImage(named: "sesac_face_\(value + 1)")
    }
}
