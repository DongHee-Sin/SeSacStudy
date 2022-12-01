//
//  ImageLabelView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/12/01.
//

import UIKit


final class ImageLabelView: BaseView {
    
    // MARK: - Propertys
    let image = UIImageView()
    
    let label = UILabel().then {
        $0.textColor = R.color.gray7()
        $0.font = .customFont(.title3_M14)
    }
    
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        self.backgroundColor = .clear
        
        [image, label].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        label.snp.makeConstraints { make in
            make.top.trailing.bottom.equalTo(self)
        }
        
        image.snp.makeConstraints { make in
            make.height.equalTo(label)
            make.width.equalTo(image.snp.height)
            make.trailing.equalTo(label.snp.leading).offset(-5)
            make.leading.equalTo(self)
            make.centerY.equalTo(self)
        }
    }

}
