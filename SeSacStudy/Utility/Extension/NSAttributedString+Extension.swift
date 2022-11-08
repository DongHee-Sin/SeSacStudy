//
//  NSAttributedString+Extension.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/07.
//

import UIKit


extension NSAttributedString {
    
    static func attributedString(text: String, style: FontStyle, color: UIColor?, highlightedText: String? = nil, highlightedColor: UIColor? = nil) -> NSAttributedString {
        
        let nsStyle: NSMutableParagraphStyle = {
            let nsStyle = NSMutableParagraphStyle()
            nsStyle.maximumLineHeight = style.lineHeight
            nsStyle.minimumLineHeight = style.lineHeight
            nsStyle.alignment = .center
            return nsStyle
        }()
        
        let attributed: [NSAttributedString.Key: Any] = [
            .paragraphStyle: nsStyle,
            .foregroundColor: color,
            .font: UIFont.customFont(style),
            .baselineOffset: (style.lineHeight - style.size) / 4
        ]
        
        let result = NSMutableAttributedString(string: text, attributes: attributed)
        
        if let highlightedText, let highlightedColor {
            let textRange = (highlightedText as NSString).range(of: highlightedText)
            
            let attributed: [NSAttributedString.Key: Any] = [
                .paragraphStyle: nsStyle,
                .foregroundColor: highlightedColor,
                .font: UIFont.customFont(style),
                .baselineOffset: (style.lineHeight - style.size) / 4
            ]
            
            result.setAttributes(attributed, range: textRange)
        }
        
        return result
    }
    
}
