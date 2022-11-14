//
//  ProfileBackgroundImageView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/14.
//

import UIKit


enum ProfileImageButtonType {
    case request
    case accept
}


final class ProfileBackgroundImageView: BaseView {
    
    convenience init(img: UIImage, buttonType: ProfileImageButtonType? = nil) {
        self.init(frame: CGRect())
        
        self.imageView.image = img
        
        if let buttonType {
            addButton(buttonType: buttonType)
        }
    }
    
    
    
    // MARK: - Propertys
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 10
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
}
