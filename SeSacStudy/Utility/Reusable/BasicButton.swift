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
}




extension BasicButton {
    
    convenience init(status: ButtonStatus) {
        self.init(frame: CGRect())
        //setButtonStyle(status: status)
    }
    
    
//    func setButtonStyle(status: ButtonStatus) {
//        switch status {
//        case .inactive:
//            <#code#>
//        case .fill:
//            <#code#>
//        case .outline:
//            <#code#>
//        case .cancel:
//            <#code#>
//        case .disable:
//            <#code#>
//        }
//    }
    
}
