//
//  EnterPhoneNumberView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/08.
//

import UIKit


/// DescriptionLabel + ReusableTextField + Button
final class ReusableViewWithTextField: BaseView {
    
    // MARK: - Propertys
    let reusableView = ReusableInitialView()
    
    let reusableTextField = ReusableTextField()
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [reusableView, reusableTextField].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        reusableView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        
        reusableTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self).inset(16)
            make.centerY.equalTo(reusableView.stackView)
        }
    }
}
