//
//  EnterBirthDayViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/10.
//

import UIKit


final class EnterBirthDayViewController: BaseViewController {
    
    // MARK: - Propertys
    
    
    
    
    // MARK: - Life Cycle
    private let customView = EnterBirthDayView()
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        customView.reusableView.textStackView.addText(title: "생년월일을 알려주세요")
        customView.reusableView.button.setTitle("다음", for: .normal)
        
        setTextField()
        bind()
    }
    
    
    private func setTextField() {
        customView.textFields.forEach {
            //$0.reusableTextField.textField.delegate = self
            $0.reusableTextField.textField.inputView = customView.datePickerView
        }
    }
    
    
    private func bind() {
        customView.reusableView.button.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.transition(EnterEmailViewController(), transitionStyle: .push)
            }
            .disposed(by: disposeBag)
    }
}




// MARK: - TextField Delegate
extension EnterBirthDayViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        customView.datePickerView.date
    }
    
}
