//
//  CustomAlertView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/16.
//

import UIKit


final class CustomAlertView: BaseView {
    
    // MARK: - Propertys
    private let backgroundView = UIView().then {
        $0.layer.cornerRadius = 16
        $0.backgroundColor = R.color.white()
    }
    
    let title = UILabel().then {
        $0.textAlignment = .center
        $0.font = .customFont(.body1_M16)
        $0.textColor = R.color.black()
    }
    
    let message = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = .customFont(.title4_R14)
        $0.textColor = R.color.black()
    }
    
    let okButton = BasicButton(status: .fill).then {
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.font = .customFont(.body3_R14)
    }
    
    let cancelButton = BasicButton(status: .cancel).then {
        $0.setTitle("취소", for: .normal)
        $0.titleLabel?.font = .customFont(.body3_R14)
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        self.backgroundColor = R.color.black()?.withAlphaComponent(0.5)
        
        [title, message, okButton, cancelButton].forEach {
            backgroundView.addSubview($0)
        }
        
        self.addSubview(backgroundView)
    }
    
    
    override func setConstraint() {
        backgroundView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.center.equalTo(self)
        }
        
        title.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }
        
        message.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(message.snp.bottom).offset(16)
            make.leading.bottom.equalToSuperview().inset(16)
            make.trailing.equalTo(okButton.snp.leading).offset(-8)
            make.width.equalTo(okButton)
            make.height.equalTo(48)
        }
        
        okButton.snp.makeConstraints { make in
            make.top.equalTo(message.snp.bottom).offset(16)
            make.trailing.bottom.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
}
