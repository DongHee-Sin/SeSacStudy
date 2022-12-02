//
//  EnterNicknameViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/10.
//

import UIKit


final class EnterNicknameViewController: RxBaseViewController {
    
    // MARK: - Propertys
    private let viewModel = EnterNicknameViewModel()
    
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
        customView.reusableTextField.textField.delegate = self
        
        setInitialUI()
        
        bind()
    }
    
    
    private func setInitialUI() {
        customView.reusableView.textStackView.addText(title: "닉네임을 입력해 주세요")
        customView.reusableView.button.setTitle("다음", for: .normal)
        
        customView.reusableTextField.textField.keyboardType = .default
        customView.reusableTextField.textField.placeholder = Placeholder.nickname.rawValue
        
        customView.reusableTextField.textField.becomeFirstResponder()
    }
    
    
    private func bind() {
        let input = EnterNicknameViewModel.Input(buttonTap: customView.reusableView.button.rx.tap, nickname: customView.reusableTextField.textField.rx.text)
        let output = viewModel.transform(input: input)
        
        output.buttonTap
            .withUnretained(self)
            .bind { (vc, _) in
                if vc.nicknameValidation {
                    let birthdayVC = EnterBirthDayViewController()
                    vc.transition(birthdayVC, transitionStyle: .push)
                }else {
                    vc.showToast(message: "닉네임은 1자 이상 10자 이내로 부탁드려요")
                }
            }
            .disposed(by: disposeBag)
        
        
        output.nickname
            .bind { value in
                SignUpModel.shared.add(nickname: value)
            }
            .disposed(by: disposeBag)

        
        output.validation
            .withUnretained(self)
            .bind { (vc, value) in
                vc.nicknameValidation = value
            }
            .disposed(by: disposeBag)
    }
}




// MARK: - TextField Delegate
extension EnterNicknameViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard (textField.text ?? "").count < 10 || string.isEmpty else {
            showToast(message: "닉네임은 1자 이상 10자 이내로 부탁드려요")
            return false
        }
        
        guard string != " " else {
            showToast(message: "공백은 입력할 수 없습니다")
            return false
        }
        
        return true
    }
    
}
