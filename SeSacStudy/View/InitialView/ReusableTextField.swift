//
//  ReusableTextField.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/10.
//

import UIKit


/// textField + lineView
final class ReusableTextField: BaseView {
    
    // MARK: - Propertys
    let textField = UITextField().then {
        $0.font = .customFont(.title4_R14)
    }
    
    let lineView = UIView().then {
        $0.backgroundColor = R.color.gray3()
    }
    
    
    
    
    // MARK: - Methdos
    override func configureUI() {
        [textField, lineView].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        lineView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self)
            make.bottom.equalTo(self)
            make.height.equalTo(1)
        }
        
        textField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(lineView).inset(6)
            make.bottom.equalTo(lineView.snp.top).offset(-12)
            make.top.equalTo(self)
        }
    }
    
}
