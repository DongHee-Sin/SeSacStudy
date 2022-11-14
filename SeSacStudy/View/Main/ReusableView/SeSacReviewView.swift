//
//  SeSacReviewView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/14.
//

import UIKit


final class SeSacReviewView: BaseView {
    
    // MARK: - Propertys
    private let label = UILabel().then {
        $0.textColor = R.color.black()
        $0.font = .customFont(.title6_R12)
        $0.text = "새싹 리뷰"
    }
    
    let textView = UITextView().then {
        $0.textColor = R.color.black()
        $0.font = .customFont(.body3_R14)
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [label, textView].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        label.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self).inset(16)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(16)
            make.bottom.leading.trailing.equalTo(self).inset(16)
        }
    }
}
