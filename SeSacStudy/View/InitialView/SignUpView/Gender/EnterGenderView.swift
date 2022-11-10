//
//  EnterGenderView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/10.
//

import UIKit


final class EnterGenderView: BaseView {
    
    // MARK: - Propertys
    let reusableView = ReusableInitialView()
    
    private let stackView = UIStackView().then {
        $0.spacing = 16
        $0.distribution = .fillEqually
        $0.axis = .horizontal
    }
    
    lazy var manButton = UIButton().then {
        setButtonBorderStyle($0)
        $0.configuration = buttonConfiguration(title: "남자", img: R.image.man())
    }
    
    lazy var womanButton = UIButton().then {
        setButtonBorderStyle($0)
        $0.configuration = buttonConfiguration(title: "여자", img: R.image.woman())
    }
    
    
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [manButton, womanButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [reusableView, stackView].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        reusableView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(reusableView.textStackView.snp.bottom).offset(32)
            make.bottom.equalTo(reusableView.button.snp.top).offset(-32)
            make.horizontalEdges.equalTo(self).inset(16)
        }
    }
    
    
    private func buttonConfiguration(title: String, img: UIImage?) -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        config.title = title
        config.image = img
        config.baseForegroundColor = R.color.black()
        config.imagePadding = 12
        config.imagePlacement = .top
        config.cornerStyle = .large
        return config
    }
    
    
    private func setButtonBorderStyle(_ button: UIButton) {
        button.layer.cornerRadius = 10
        button.layer.borderColor = R.color.gray3()?.cgColor
        button.layer.borderWidth = 1
    }
}
