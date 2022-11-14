//
//  ProfileNicknameView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/15.
//

import UIKit


final class ProfileNicknameView: BaseView {
    
    // MARK: - Propertys
    let label = UILabel().then {
        $0.text = "김새싹"
        $0.textColor = R.color.black()
        $0.font = .customFont(.title1_M16)
    }
    
//    let image = UIImageView().then {
//        $0.ima
//    }
    
    
    
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [label].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        label.snp.makeConstraints { make in
            make.leading.top.bottom.equalTo(self).inset(16)
        }
    }
    
}
