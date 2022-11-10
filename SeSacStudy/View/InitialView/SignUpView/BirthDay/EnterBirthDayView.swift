//
//  EnterBirthDayView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/10.
//

import UIKit


final class EnterBirthDayView: BaseView {
    
    // MARK: - Propertys
    let reusableView = ReusableInitialView()
    
    let textField = UITextField().then {
        $0.font = .customFont(.title4_R14)
    }
    
    let lineView = UIView().then {
        $0.backgroundColor = R.color.gray3()
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [reusableView, textField, lineView].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        reusableView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        textField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self).inset(28)
            make.centerY.equalTo(reusableView.stackView)
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalTo(self).inset(16)
            make.top.equalTo(textField.snp.bottom).offset(12)
        }
    }
}
