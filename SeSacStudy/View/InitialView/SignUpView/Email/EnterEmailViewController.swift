//
//  EnterEmailViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/10.
//

import UIKit


final class EnterEmailViewController: BaseViewController {
    
    // MARK: - Propertys
    var viewModel: SignUpViewModel?
    
    private var emailValidation: Bool = false {
        didSet {
            if emailValidation == oldValue { return }
            customView.reusableView.button.setButtonStyle(status: emailValidation ? .fill : .cancel)
        }
    }
    
    
    
    
    // MARK: - Life Cycle
    private let customView = ReusableViewWithTextField()
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        setInitialUI()
        
        bind()
    }
    
    
    private func setInitialUI() {
        customView.reusableView.textStackView.addText(title: "이메일을 입력해 주세요", subTitle: "휴대폰 번호 변경 시 인증을 위해 사용해요")
        customView.reusableView.button.setTitle("다음", for: .normal)
        
        customView.reusableTextField.textField.keyboardType = .emailAddress
        customView.reusableTextField.textField.placeholder = "SeSAC@email.com"
        
        customView.reusableTextField.textField.becomeFirstResponder()
    }
    
    
    private func bind() {
        customView.reusableView.button.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.transition(EnterGenderViewController(), transitionStyle: .push)
            }
            .disposed(by: disposeBag)
    }
}
