//
//  ReusableInitialView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/08.
//

import UIKit

import SnapKit
import Then


/// DescriptionLabel + Button
final class ReusableInitialView: BaseView {
    
    // MARK: - Propertys
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 200
    }
    
    let textStackView = TextStackView()
    
    let button = BasicButton(status: .cancel).then {
        $0.titleLabel?.font = .customFont(.body3_R14)
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [textStackView, button].forEach {
            stackView.addArrangedSubview($0)
        }
        
        self.addSubview(stackView)
    }
    
    
    override func setConstraint() {
        button.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self).inset(16)
            let height = UIScreen.main.bounds.height / 2
            make.bottom.equalTo(self.snp.bottom).offset(-height + 50)
        }
    }
    
}
