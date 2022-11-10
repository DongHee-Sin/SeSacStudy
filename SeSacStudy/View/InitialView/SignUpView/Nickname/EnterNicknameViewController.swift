//
//  EnterNicknameViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/10.
//

import UIKit


final class EnterNicknameViewController: BaseViewController {
    
    // MARK: - Propertys
    private let viewModel = SignUpViewModel()
    
    private var nicknameValidation: Bool = false {
        didSet {
            if nicknameValidation == oldValue { return }
            customView.reusableTextField.lineView.backgroundColor = nicknameValidation ? R.color.black() : R.color.gray3()
            customView.reusableView.button.setButtonStyle(status: nicknameValidation ? .fill : .cancel)
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
        customView.reusableView.textStackView.addText(title: "닉네임을 입력해 주세요")
        customView.reusableView.button.setTitle("다음", for: .normal)
        
        customView.reusableTextField.textField.delegate = self
        
        customView.reusableTextField.textField.keyboardType = .numberPad
        customView.reusableTextField.textField.placeholder = "10자 이내로 입력"
        
        bind()
    }
    
    
    private func bind() {
        customView.reusableView.button.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                let birthdayVC = EnterBirthDayViewController()
                birthdayVC.viewModel = vc.viewModel
                vc.transition(birthdayVC, transitionStyle: .push)
            }
            .disposed(by: disposeBag)
        
        
        customView.reusableTextField.textField.rx.text.orEmpty
            .bind(to: viewModel.nickname)
            .disposed(by: disposeBag)
        
        
        viewModel.nickname
            .withUnretained(self)
            .bind { (vc, text) in
                vc.viewModel.signUp.nick = text
            }
            .disposed(by: disposeBag)
        
        viewModel.nickname
            .map { $0.isEmpty }
            .withUnretained(self)
            .bind { (vc, value) in
                vc.nicknameValidation = !value
            }
            .disposed(by: disposeBag)
    }
}




// MARK: - TextField Delegate
extension EnterNicknameViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard (textField.text ?? "").count < 10 || string.isEmpty else {
            showToast(message: "최대 10자리까지 입력할 수 있습니다")
            return false
        }
        
        return true
    }
    
}
