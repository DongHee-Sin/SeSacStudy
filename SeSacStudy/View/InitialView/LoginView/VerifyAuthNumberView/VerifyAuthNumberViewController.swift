//
//  VerifyAuthNumberViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/09.
//

import UIKit

import RxSwift
import RxCocoa


final class VerifyAuthNumberViewController: BaseViewController {
    
    // MARK: - Propertys
    private let viewModel = VerifyAuthNumberViewModel()
    
    private var authNumberValidation: Bool = false {
        didSet {
            if authNumberValidation == oldValue { return }
            customView.reusableView.button.setButtonStyle(status: authNumberValidation ? .fill : .cancel)
        }
    }
    
    var verificationID: String?
    
    
    
    
    // MARK: - Life Cycle
    private let customView = VerifyAuthNumberView()
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        customView.reusableView.textStackView.addText(title: "인증번호가 문자로 전송되었어요")
        customView.reusableView.button.setTitle("인증하고 시작하기", for: .normal)
        
        customView.textField.delegate = self
        
        bind()
    }
    
    
    private func bind() {
        let input = VerifyAuthNumberViewModel.Input(authNumberText: customView.textField.rx.text, resendTap: customView.resendButton.rx.tap, verifyTap: customView.reusableView.button.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.isTextEntered.withUnretained(self)
            .bind { (vc, value) in
                vc.customView.lineView.backgroundColor = value ? R.color.black() : R.color.gray3()
            }
            .disposed(by: disposeBag)
        
        
        output.authNumberValidatoin
            .withUnretained(self)
            .bind { (vc, value) in
                vc.authNumberValidation = value
            }
            .disposed(by: disposeBag)
        
        
        output.resendTap.withUnretained(self)
            .bind { (vc, _) in
                /// 1. 타이머 체크 (10초 이상 지났는지?)
                ///     지났다? : 타이머 초기화, 재전송
                ///     안지남? : toast 메시지 띄우기
            }
            .disposed(by: disposeBag)
        
        
        output.verifyTap.withUnretained(self)
            .bind { (vc, _) in
                /// 1. 타이머 체크 (60초 지나지 않았는지?)
                /// 2. 파베인증
                ///     성공 : API 요청 (회원인지 아닌지)
                ///     실패 : Alert 띄우기
                FirebaseAuthManager.share.signIn(id: vc.verificationID ?? "", code: vc.customView.textField.text ?? "") { result in
                    switch result {
                    case .success(let result):
                        print("인증 성공 => ")
                    case .failure(let error):
                        vc.showAlert(title: "인증에 실패했습니다", message: error.localizedDescription)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}




// MARK: - TextField Delegate
extension VerifyAuthNumberViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }
        
        guard Int(string) != nil else {
            showToast(message: "숫자만 입력해주세요")
            return false
        }
        
        guard (textField.text ?? "").count < 6 else {
            showToast(message: "최대 6자리 숫자까지 입력할 수 있습니다")
            return false
        }
        
        return true
    }
}
