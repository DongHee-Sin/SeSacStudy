//
//  EnterEmailViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/10.
//

import UIKit


final class EnterEmailViewController: BaseViewController {
    
    // MARK: - Propertys
    private let viewModel = EnterEmailViewModel()
    
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
        let input = EnterEmailViewModel.Input(buttonTap: customView.reusableView.button.rx.tap, email: customView.reusableTextField.textField.rx.text)
        let output = viewModel.transform(input: input)
        
        output.buttonTap
            .withUnretained(self)
            .bind { (vc, _) in
                if vc.emailValidation {
                    let genderVC = EnterGenderViewController()
                    vc.transition(genderVC, transitionStyle: .push)
                }else {
                    vc.showToast(message: "이메일 형식이 올바르지 않습니다")
                }
            }
            .disposed(by: disposeBag)
        
        
        output.email
            .bind { value in
                SignUpModel.shared.add(email: value)
            }
            .disposed(by: disposeBag)
        
        
        output.validation
            .withUnretained(self)
            .bind { (vc, value) in
                vc.emailValidation = value
            }
            .disposed(by: disposeBag)
    }
}
