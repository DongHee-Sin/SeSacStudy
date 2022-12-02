//
//  ProfileBackgroundImageView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/14.
//

import UIKit


final class ProfileBackgroundImageView: BaseView {
    
    enum ProfileImageButtonType {
        case request
        case accept
    }
    
    // MARK: - Propertys
    let imageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var button = BasicButton(status: .fill)
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        self.addSubview(imageView)
    }
    
    
    override func setConstraint() {
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    
    private func addButton(buttonType: ProfileImageButtonType) {
        self.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(80)
            make.top.equalTo(imageView.snp.top).offset(12)
            make.trailing.equalTo(imageView.snp.trailing).offset(-12)
        }
        
        switch buttonType {
        case .request:
            button.setTitle("요청하기", for: .normal)
            button.backgroundColor = R.color.error()
        case .accept:
            button.setTitle("수락하기", for: .normal)
            button.backgroundColor = R.color.success()
        }
    }
    
    
    func setImageView(img: UIImage?, buttonType: ProfileImageButtonType? = nil) {
        self.imageView.image = img
        
        if let buttonType {
            addButton(buttonType: buttonType)
        }
    }
}
