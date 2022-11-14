//
//  EnterPhoneNumberViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/08.
//

import UIKit

import RxSwift
import RxCocoa


final class EnterPhoneNumberViewController: BaseViewController {
    
    // MARK: - Propertys
    private let viewModel = EnterPhoneNumberViewModel()
    
    private var phoneNumberValidation: Bool = false {
        didSet {
            if phoneNumberValidation == oldValue { return }
            customView.reusableView.button.setButtonStyle(status: phoneNumberValidation ? .fill : .cancel)
        }
    }
    
    private var phoneNumberForAuth: String? {
        return viewModel.convertPhoneNumberToKoreaFormat(customView.reusableTextField.textField.text ?? "")
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
        customView.reusableView.textStackView.addText(title: "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해 주세요")
        customView.reusableView.button.setTitle("인증 문자 받기", for: .normal)
        
        customView.reusableTextField.textField.delegate = self
        customView.reusableTextField.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        customView.reusableTextField.textField.keyboardType = .numberPad
        customView.reusableTextField.textField.placeholder = "휴대폰 번호(-없이 숫자만 입력)"
        
        bind()
    }
    
    
    private func bind() {
        let input = EnterPhoneNumberViewModel.Input(phoneNumberText: customView.reusableTextField.textField.rx.text, buttonTap: customView.reusableView.button.rx.tap)
        let output = viewModel.transform(input: input)
        

        output.phoneNumberValidatoin.withUnretained(self)
            .bind { (vc, value) in
                vc.phoneNumberValidation = value
            }
            .disposed(by: disposeBag)

        
        output.isTextEntered.withUnretained(self)
            .bind { (vc, value) in
                vc.customView.reusableTextField.lineView.backgroundColor = value ? R.color.black() : R.color.gray3()
            }
            .disposed(by: disposeBag)
        
        
        output.buttonTap.withUnretained(self)
            .bind { (vc, _) in
                if vc.phoneNumberValidation {
                    
                    FirebaseAuthManager.share.requestAuthNumber(phoneNumber: vc.phoneNumberForAuth) { result in
                        switch result {
                        case .success(let id):
                            let verifyVC = VerifyAuthNumberViewController()
                            verifyVC.verificationID = id
                            vc.transition(verifyVC, transitionStyle: .push)
                        case .failure(let error):
                            vc.showErrorAlert(error: error)
                        }
                    }
                    
                }else {
                    vc.showToast(message: "잘못된 전화번호 형식입니다.")
                }
            }
            .disposed(by: disposeBag)
    }
    
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        textField.text = viewModel.formatPhoneStyle(text)
    }
}




// MARK: - TextField Delegate
extension EnterPhoneNumberViewController: UITextFieldDelegate {    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }
        
        guard Int(string) != nil else {
            showToast(message: "숫자만 입력해주세요")
            return false
        }
        
        guard (textField.text ?? "").count < 13 else {
            showToast(message: "최대 11자리 숫자까지 입력할 수 있습니다")
            return false
        }
        
        return true
    }
}
