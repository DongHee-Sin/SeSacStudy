//
//  VerifyAuthNumberView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/09.
//

import UIKit


final class VerifyAuthNumberView: BaseView {
    
    // MARK: - Propertys
    let reusableView = ReusableInitialView()
    
    let textField = UITextField().then {
        $0.keyboardType = .numberPad
        $0.font = .customFont(.title4_R14)
        $0.placeholder = Placeholder.authNumber.rawValue
    }
    
    let lineView = UIView().then {
        $0.backgroundColor = R.color.gray3()
    }
    
    let timerLabel = UILabel().then {
        $0.setContentHuggingPriority(.defaultHigh, for:.horizontal)
        $0.textColor = R.color.green()
        $0.font = .customFont(.title3_M14)
    }
    
    let resendButton = BasicButton(status: .cancel).then {
        $0.titleLabel?.font = .customFont(.body3_R14)
        $0.setTitle("재전송", for: .normal)
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [reusableView, textField, lineView, timerLabel, resendButton].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        reusableView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        resendButton.snp.makeConstraints { make in
            make.centerY.equalTo(reusableView.stackView)
            make.trailing.equalTo(self).offset(-16)
            make.width.equalTo(72)
            make.height.equalTo(40)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.centerY.equalTo(resendButton)
            make.trailing.equalTo(resendButton.snp.leading).offset(-20)
        }
        
        textField.snp.makeConstraints { make in
            make.centerY.equalTo(resendButton)
            make.trailing.equalTo(timerLabel.snp.leading).offset(-20)
            make.leading.equalTo(self).offset(28)
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalTo(self).offset(16)
            make.trailing.equalTo(resendButton.snp.leading).offset(-16)
            make.top.equalTo(textField.snp.bottom).offset(12)
        }
    }
}
