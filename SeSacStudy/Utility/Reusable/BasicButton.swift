//
//  BasicButton.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/07.
//

import UIKit


enum ButtonStatus {
    case inactive
    case fill
    case outline
    case cancel
    case disable
}


final class BasicButton: UIButton {
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    convenience init(status: ButtonStatus) {
        self.init(frame: CGRect())
        
        self.layer.cornerRadius = 10
        buttonStatus = status
        setButtonStyle(status: status)
    }
    
    
    
    
    // MARK: - Propertys
    var buttonStatus: ButtonStatus = .cancel {
        didSet {
            switch buttonStatus {
            case .inactive:
                configureStyle(titleColor: R.color.black(), backgroundColor: R.color.white(), borderColor: R.color.gray2())
            case .fill:
                configureStyle(titleColor: R.color.white(), backgroundColor: R.color.green())
            case .outline:
                configureStyle(titleColor: R.color.green(), backgroundColor: R.color.white(), borderColor: R.color.green())
            case .cancel:
                configureStyle(titleColor: R.color.black(), backgroundColor: R.color.gray2())
            case .disable:
                configureStyle(titleColor: R.color.gray3(), backgroundColor: R.color.gray6())
            }
        }
    }
}




extension BasicButton {
    
    func setButtonStyle(status: ButtonStatus) {
        buttonStatus = status
    }
}




extension BasicButton {
    
    private func configureStyle(titleColor: UIColor?, backgroundColor: UIColor?, borderColor: UIColor? = nil) {
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        
        if let borderColor {
            self.layer.borderColor = borderColor.cgColor
            self.layer.borderWidth = 1
        }
    }
    
}
