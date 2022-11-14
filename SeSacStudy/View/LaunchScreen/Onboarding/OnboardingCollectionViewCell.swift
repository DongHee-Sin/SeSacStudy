//
//  OnboardingCollectionViewCell.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/07.
//

import UIKit

import SnapKit
import Then


final class OnboardingCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Propertys
    private let textLabel = UILabel().then {
        $0.numberOfLines = 0
    }
    
    private let mainImageView = UIImageView()
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [textLabel, mainImageView].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        mainImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self).inset(8)
            make.height.equalTo(mainImageView.snp.width)
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).offset(-20)
        }
        
        textLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self)
            make.bottom.equalTo(mainImageView.snp.top)
            make.top.equalTo(self)
        }
    }
    
    
    func updateCell(data: Onboarding) {
        textLabel.attributedText = .attributedString(text: data.title, style: .display_R20, color: R.color.black(), highlightedText: data.highlightedText, highlightedColor: data.highlightedColor)
        mainImageView.image = data.image
    }
}
