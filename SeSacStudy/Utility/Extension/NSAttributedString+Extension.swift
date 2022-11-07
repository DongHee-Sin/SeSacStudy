//
//  NSAttributedString+Extension.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/07.
//

import UIKit


extension NSAttributedString {
    
    static func attributedString(text: String, style: FontStyle, color: UIColor) -> NSAttributedString {
        
        let nsStyle: NSMutableParagraphStyle = {
            let nsStyle = NSMutableParagraphStyle()
            nsStyle.maximumLineHeight = style.lineHeight
            nsStyle.minimumLineHeight = style.lineHeight
            return nsStyle
        }()
        
        let attributed: [NSAttributedString.Key: Any] = [
            .paragraphStyle: nsStyle,
            .foregroundColor: color,
            .font: UIFont.customFont(style),
            .baselineOffset: (style.lineHeight - style.size) / 4
        ]
        
        let result = NSMutableAttributedString(string: text, attributes: attributed)
        
        return result
    }
    
}
