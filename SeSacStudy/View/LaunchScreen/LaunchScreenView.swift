//
//  LaunchScreenView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/11.
//

import UIKit


final class LaunchScreenView: BaseView {
    
    // MARK: - Propertys
    private let stackView = UIStackView().then {
        $0.distribution = .fill
        $0.spacing = 30
        $0.axis = .vertical
    }
    
    private let splashImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = R.image.splash_logo()
    }
    
    private let textImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = R.image.txt()
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [splashImage, textImage].forEach {
            stackView.addArrangedSubview($0)
        }
        
        self.addSubview(stackView)
    }
    
    
    override func setConstraint() {
        stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self.safeAreaLayoutGuide)
            make.width.equalTo(self).multipliedBy(0.83)
        }
        
        splashImage.snp.makeConstraints { make in
            make.height.equalTo(splashImage.snp.width)
        }
        
        textImage.snp.makeConstraints { make in
            make.height.equalTo(textImage.snp.width).multipliedBy(0.3333)
        }
    }
}
