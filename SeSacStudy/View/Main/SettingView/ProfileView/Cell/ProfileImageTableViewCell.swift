//
//  ProfileImageTableViewCell.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/15.
//

import UIKit


final class ProfileImageTableViewCell: BaseTableViewCell {
    
    // MARK: - Propertys
    let customImageView = ProfileBackgroundImageView()
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        self.addSubview(customImageView)
    }
    
    
    override func setConstraint() {
        customImageView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self)
            make.horizontalEdges.equalTo(self).inset(16)
            make.height.equalTo(customImageView.snp.width).multipliedBy(0.57)
        }
    }
}
