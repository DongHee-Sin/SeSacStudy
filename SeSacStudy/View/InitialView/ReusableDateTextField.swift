//
//  ReusableDateTextField.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/10.
//

import UIKit


/// ReusableTextField + UILabel
final class ReusableDateTextField: BaseView {
    
    // MARK: - Propertys
    let reusableTextField = ReusableTextField()
    
    let label = UILabel().then {
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.font = .customFont(.title2_R16)
        $0.textColor = R.color.black()
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [reusableTextField, label].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        reusableTextField.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self)
            make.leading.equalTo(self)
        }
        
        label.snp.makeConstraints { make in
            make.centerX.equalTo(reusableTextField.textField)
            make.trailing.equalTo(self)
        }
    }
}
