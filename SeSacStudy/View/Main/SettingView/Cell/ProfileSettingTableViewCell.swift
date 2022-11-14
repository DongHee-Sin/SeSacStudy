//
//  ProfileSettingTableViewCell.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/14.
//

import UIKit


final class ProfileSettingTableViewCell: BaseTableViewCell {
    
    // MARK: - Propertys
    let image = UIImageView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = R.color.gray2()?.cgColor
        $0.layer.cornerRadius = 25
        $0.contentMode = .scaleAspectFill
    }
    
    let title = UILabel().then {
        $0.font = .customFont(.title1_M16)
        $0.textColor = R.color.black()
    }
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [image, title].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        image.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(20)
            make.centerY.equalTo(self)
            make.width.height.equalTo(50)
        }
        
        title.snp.makeConstraints { make in
            make.leading.equalTo(image.snp.trailing).offset(15)
            make.centerY.equalTo(image)
        }
    }
    
    
    func updateCell(_ data: SettingViewData) {
        image.image = data.image
        title.text = data.title
    }
    
}
