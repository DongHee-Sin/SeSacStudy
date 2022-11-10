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
    
    private let stackView = UIStackView().then {
        $0.spacing = 23
        $0.distribution = .fillEqually
        $0.axis = .horizontal
    }
    
    let year = ReusableDateTextField().then {
        $0.label.text = "년"
    }
    
    let month = ReusableDateTextField().then {
        $0.label.text = "월"
    }
    
    let day = ReusableDateTextField().then {
        $0.label.text = "일"
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [year, month, day].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [reusableView, stackView].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        reusableView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
//        textField.snp.makeConstraints { make in
//            make.horizontalEdges.equalTo(self).inset(28)
//            make.centerY.equalTo(reusableView.stackView)
//        }
//
//        lineView.snp.makeConstraints { make in
//            make.height.equalTo(1)
//            make.horizontalEdges.equalTo(self).inset(16)
//            make.top.equalTo(textField.snp.bottom).offset(12)
//        }
        
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self).inset(16)
            make.centerY.equalTo(reusableView.stackView)
        }
    }
}
