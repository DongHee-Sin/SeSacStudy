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
    let textImage = UIImageView().then {
        $0.image = UIImage(named: "onboarding_txt1")
    }
    
    let mainImage = UIImageView().then {
        $0.image = UIImage(named: "onboarding_img1")
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [textImage, mainImage].forEach {
            self.addSubview($0)
        }
    }
    
    
//    override func setConstraint() {
//        <#code#>
//    }
}
