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
    }
    
    
    private func bind() {
        let input = VerifyAuthNumberViewModel.Input(authNumberText: customView.textField.rx.text, resendTap: customView.resendButton.rx.tap, verifyTap: customView.reusableView.button.rx.tap)
        let output = viewModel.transform(input: input)
        
//        output.isTextEntered.withUnretained(self)
//            .bind(onNext: <#T##((VerifyAuthNumberViewController, Bool)) -> Void#>)
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
