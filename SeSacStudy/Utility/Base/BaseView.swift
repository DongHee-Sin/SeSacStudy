//
//  BaseView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/07.
//

import UIKit


class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = R.color.white()
        
        configureUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    func configureUI() {}
    
    func setConstraint() {}
}
