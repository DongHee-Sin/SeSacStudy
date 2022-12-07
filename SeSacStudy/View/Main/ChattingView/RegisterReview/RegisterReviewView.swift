//
//  RegisterReviewView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/12/07.
//

import UIKit


final class RegisterReviewView: BaseView {
    
    // MARK: - Propertys
    private let stackView = UIStackView().then {
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        $0.clipsToBounds = true
        $0.spacing = 24
        $0.axis = .vertical
        $0.layer.cornerRadius = 20
        $0.backgroundColor = R.color.white()
    }
    
    let titleView = RegisterReviewTitleView()
    
    let sesacTitleView = SeSacTitleStackView()
    
    let reviewTextView = UITextView().then {
        $0.text = Placeholder.registerReview.rawValue
        $0.textColor = R.color.gray7()
        $0.layer.cornerRadius = 8
        $0.contentInset = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 12)
        $0.backgroundColor = R.color.gray1()
        $0.font = .customFont(.body3_R14)
    }
    
    let registerReviewButton = BasicButton(status: .disable).then {
        $0.titleLabel?.font = .customFont(.body3_R14)
        $0.setTitle("리뷰 등록하기", for: .normal)
    }
    
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        self.backgroundColor = R.color.black()?.withAlphaComponent(0.5)
        
        [titleView, sesacTitleView, reviewTextView, registerReviewButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        self.addSubview(stackView)
    }
    
    
    override func setConstraint() {
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.center.equalTo(self)
        }
        
        reviewTextView.snp.makeConstraints { make in
            make.height.equalTo(124)
        }
        
        registerReviewButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}




extension RegisterReviewView {
    convenience init(nick: String) {
        self.init(frame: CGRect())
        
        titleView.subTitle.text = "\(nick)님과의 스터디는 어떠셨나요?"
    }
}
