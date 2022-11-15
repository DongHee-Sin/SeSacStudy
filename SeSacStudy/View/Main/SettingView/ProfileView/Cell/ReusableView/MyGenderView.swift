//
//  MyGenderView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/15.
//

import UIKit


final class MyGenderView: BaseView {
    
    // MARK: - Propertys
    private let label = UILabel().then {
        $0.textColor = R.color.black()
        $0.font = .customFont(.title4_R14)
        $0.text = "내 성별"
    }
    
    let manButton = BasicButton(status: .inactive).then {
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.setTitle("  남자  ", for: .normal)
    }

    let womanButton = BasicButton(status: .inactive).then {
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.setTitle("  여자  ", for: .normal)
    }

    
    
    
    // MARK: - Methods
    override func configureUI() {
        [label, manButton, womanButton].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        womanButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.verticalEdges.equalTo(self).inset(8)
            make.trailing.equalTo(self)
        }
        
        manButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.verticalEdges.equalTo(self).inset(8)
            make.trailing.equalTo(womanButton.snp.leading).offset(-8)
        }
        
        label.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(manButton.snp.leading).offset(-8)
        }
    }
}
