//
//  ProfileNicknameView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/15.
//

import UIKit


final class ProfileNicknameView: BaseView {
    
    // MARK: - Propertys
    let label = UILabel().then {
        $0.text = "김새싹"
        $0.textColor = R.color.black()
        $0.font = .customFont(.title1_M16)
    }
    
    private let image = UIImageView().then {
        $0.tintColor = R.color.gray7()
    }
    
    
    
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [label, image].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        label.snp.makeConstraints { make in
            make.leading.top.bottom.equalTo(self).inset(16)
            make.trailing.equalTo(image.snp.leading).offset(-10)
        }
        
        image.snp.makeConstraints { make in
            make.top.bottom.trailing.equalTo(self).inset(26)
            
        }
    }
    
    
    func updateCell(isExpand: Bool) {
        image.image = UIImage(systemName: isExpand ? "chevron.down" : "chevron.up")
    }
    
}
