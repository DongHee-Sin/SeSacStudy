//
//  FrequentStudyView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/15.
//

import UIKit


final class FrequentStudyView: BaseView {
    
    // MARK: - Propertys
    private let label = UILabel().then {
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.textColor = R.color.black()
        $0.font = .customFont(.title4_R14)
        $0.text = "자주 하는 스터디"
    }
    
    let textField = ReusableTextField().then {
        $0.textField.placeholder = "스터디를 입력해 주세요"
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [label, textField].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        label.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self)
            make.leading.equalTo(self)
        }
        
        textField.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self)
            make.trailing.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.5)
        }
    }
    
    
    func updateView(study: String) {
        textField.textField.text = study
    }
}
