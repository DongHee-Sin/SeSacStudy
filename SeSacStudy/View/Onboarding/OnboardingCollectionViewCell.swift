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
    let textImageView = UIImageView().then {
        $0.image = UIImage(named: "onboarding_txt1")
    }
    
    let mainImageView = UIImageView().then {
        $0.image = UIImage(named: "onboarding_img1")
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [textImageView, mainImageView].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        mainImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self).inset(8)
            make.height.equalTo(mainImageView.snp.width)
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).offset(-30)
        }
        
        textImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self)
            make.bottom.equalTo(mainImageView.snp.top)
            make.top.equalTo(self)
        }
    }
}
