//
//  TextStackView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/08.
//

import UIKit

import SnapKit
import Then


final class TextStackView: BaseView {
    
    // MARK: - Propertys
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    private let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = R.color.black()
        $0.font = .customFont(.display_R20)
    }
    
    private lazy var subTitleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = R.color.gray7()
        $0.font = .customFont(.title2_R16)
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        stackView.addArrangedSubview(titleLabel)
        self.addSubview(stackView)
    }
    
    
    override func setConstraint() {
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    
    func addText(title: String, subTitle: String? = nil) {
        titleLabel.text = title
        
        if let subTitle {
            subTitleLabel.text = subTitle
            stackView.addArrangedSubview(subTitleLabel)
        }
    }
}
