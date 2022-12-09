//
//  RegisterReviewTitleView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/12/07.
//

import UIKit


final class RegisterReviewTitleView: BaseView {
    
    // MARK: - Propertys
    private let titleLabel = UILabel().then {
        $0.font = .customFont(.title3_M14)
        $0.textColor = R.color.black()
        $0.text = "리뷰 등록"
    }
    
    let dismissButton = UIButton().then {
        $0.setImage(R.image.close_big(), for: .normal)
    }
    
    let subTitle = UILabel().then {
        $0.font = .customFont(.title4_R14)
        $0.textColor = R.color.green()
    }
    
    
    
    
    
    // MARK: - Methdes
    override func configureUI() {
        [titleLabel, dismissButton, subTitle].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        dismissButton.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.trailing.equalToSuperview().inset(17)
            make.centerY.equalTo(titleLabel)
        }
        
        subTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(17)
            make.bottom.equalToSuperview()
        }
    }
}
