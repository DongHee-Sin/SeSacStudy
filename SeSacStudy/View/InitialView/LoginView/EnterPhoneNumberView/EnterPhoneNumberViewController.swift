//
//  EnterPhoneNumberViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/08.
//

import UIKit

import RxSwift
import RxCocoa
import FirebaseAuth


final class EnterPhoneNumberViewController: BaseViewController {
    
    // MARK: - Propertys
    private let viewModel = EnterPhoneNumberViewModel()
    
    private var phoneNumberValidation: Bool = false {
        didSet {
            if phoneNumberValidation == oldValue { return }
            customView.reusableView.button.setButtonStyle(status: phoneNumberValidation ? .fill : .cancel)
        }
    }
    
    
    
    
    // MARK: - Life Cycle
    private let customView = EnterPhoneNumberView()
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
        
        customView.textField.delegate = self
        customView.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        bind()
    }
    
    
    private func bind() {
        let input = EnterPhoneNumberViewModel.Input(phoneNumberText: customView.textField.rx.text, buttonTap: customView.reusableView.button.rx.tap)
        let output = viewModel.transform(input: input)
        

        output.phoneNumberValidatoin.withUnretained(self)
            .bind { (vc, value) in
                vc.phoneNumberValidation = value
            }
            .disposed(by: disposeBag)

        
        output.isTextEntered.withUnretained(self)
            .bind { (vc, value) in
                vc.customView.lineView.backgroundColor = value ? R.color.black() : R.color.gray3()
            }
            .disposed(by: disposeBag)
        
        
        output.buttonTap.withUnretained(self)
            .bind { (vc, _) in
                if vc.phoneNumberValidation {
                    vc.requestAuthNumber()

                    let verifyVC = VerifyAuthNumberViewController()
                    vc.transition(verifyVC, transitionStyle: .push)
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




// MARK: - Firebase Auth
extension EnterPhoneNumberViewController {

    func requestAuthNumber() {
        PhoneAuthProvider.provider()
            .verifyPhoneNumber("+82 10-1234-5678", uiDelegate: nil) { (verificationID, error) in
                if let id = verificationID {
                    print("id : \(id)")
                }
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }
    }



//    func verificationButtonClicked(_ sender: UIButton) {
//        guard let verificationID = UserDefaults.standard.string(forKey: "verificationID"), let verificationCode = verificationNumberTextField.text else {
//            return
//        }
//
//        let credential = PhoneAuthProvider.provider().credential(
//            withVerificationID: verificationID,
//            verificationCode: verificationCode
//        )
//
//        logIn(credential: credential)
//    }
//
//
//    func logIn(credential: PhoneAuthCredential) {
//        Auth.auth().signIn(with: credential) { authResult, error in
//            if let error = error {
//                print(error.localizedDescription)
//                print("LogIn Failed...")
//            }
//
//
//
//            print("LogIn Success!!")
//            print("\\(authResult!)")
//        }
//    }
}

