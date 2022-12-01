//
//  ChatInputView.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/12/01.
//

import UIKit


final class ChatInputView: BaseView {
    
    // MARK: - Propertys
    private let baseView = UIView().then {
        $0.layer.cornerRadius = 8
        $0.backgroundColor = R.color.gray1()
    }
    
    let textView = UITextView().then {
        $0.text = Placeholder.chatting.rawValue
        $0.textColor = R.color.gray7()
        $0.isScrollEnabled = false
        $0.backgroundColor = .yellow
        $0.font = .customFont(.body3_R14)
        $0.centerVertically()
    }
    
    let sendButton = UIButton().then {
        $0.setImage(R.image.property1SendProperty2Inact(), for: .normal)
    }
    
    
    
    
    
    // MARK: - Methods
    override func configureUI() {
        [baseView, textView, sendButton].forEach {
            self.addSubview($0)
        }
    }
    
    
    override func setConstraint() {
        baseView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        sendButton.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.trailing.equalTo(self).inset(16)
            make.centerY.equalTo(self)
        }
        
        textView.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.top.bottom.leading.equalTo(self).inset(12)
            make.trailing.equalTo(sendButton.snp.leading).offset(-10)
        }
    }
}
