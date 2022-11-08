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
        $0.numberOfLines = 0
    }
    
    private lazy var subTitleLabel = UILabel()
    
    
    
    
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
        titleLabel.attributedText = .attributedString(text: title, style: .display_R20, color: R.color.black())
        
        if let subTitle {
            subTitleLabel.attributedText = .attributedString(text: subTitle, style: .title2_R16, color: R.color.gray7())
            stackView.addArrangedSubview(subTitleLabel)
        }
    }
}
