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
    private let viewModel = LoginViewModel()
    
    
    
    
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
        
        customView.textField.delegate = self
        customView.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        bind()
    }
    
    
    private func bind() {
//        /// 할일
//        /// 1. bind 시킬 작업들 리스트업
//        /// 2. 뷰모델에 input/output 적용
//        /// 3. 작업
        let input = LoginViewModel.Input(phoneNumberText: customView.textField.rx.text, buttonTap: customView.reusableView.button.rx.tap)
        let output = viewModel.transfrom(input: input)

        output.phoneNumberText
            .bind(to: customView.textField.rx.text)
            .disposed(by: disposeBag)


        viewModel.phoneNumber
            .map { $0.count >= 1 }
            .withUnretained(self)
            .bind { (vc, value) in
                vc.customView.lineView.backgroundColor = value ? R.color.black() : R.color.gray3()
            }
            .disposed(by: disposeBag)
    }
    
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        textField.text = formatPhoneStyle(text)
    }
}




// MARK: - TextField Delegate
extension EnterPhoneNumberViewController: UITextFieldDelegate {    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard Int(string) != nil || string.isEmpty else {
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




extension EnterPhoneNumberViewController {
    
    func formatPhoneStyle(_ text: String) -> String {
        let text = text.components(separatedBy: "-").joined()
        
        let count = text.count
        var result: [String] = []
        
        switch count {
        case 0...3: return text
        case 4...6:
            for (index, char) in text.enumerated() {
                if index == 3 {
                    result.append("-")
                }
                result.append(String(char))
            }
        case 7...10:
            for (index, char) in text.enumerated() {
                if index == 3 || index == 6 {
                    result.append("-")
                }
                result.append(String(char))
            }
        case 11:
            for (index, char) in text.enumerated() {
                if index == 3 || index == 7 { result.append("-") }
                result.append(String(char))
            }
        default: break
        }
        
        return result.joined()
    }
    
}
