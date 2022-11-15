//
//  WithdrawalView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/15.
//

import UIKit


final class WithdrawalView: BaseView {
    
    // MARK: - Propertys
    let button = UIButton().then {
        $0.contentHorizontalAlignment = .left
        $0.setTitleColor(R.color.black(), for: .normal)
        $0.titleLabel?.font = .customFont(.title4_R14)
        $0.setTitle("회원탈퇴", for: .normal)
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        self.addSubview(button)
    }
    
    
    override func setConstraint() {
        button.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
}
