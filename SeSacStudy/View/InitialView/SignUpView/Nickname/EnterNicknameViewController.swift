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
        customView.reusableView.button.setTitle("인증 문자 받기", for: .normal)
        
        customView.reusableTextField.textField.delegate = self
        
        customView.reusableTextField.textField.keyboardType = .numberPad
        customView.reusableTextField.textField.placeholder = "10자 이내로 입력"
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
