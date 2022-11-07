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
        
        self.bounds = CGRect(x: 0, y: 0, width: 0, height: 100)
        self.setTitle("기본", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}




extension BasicButton {
    
    convenience init(status: ButtonStatus) {
        self.init(frame: CGRect())
        
        
    }
    
}
