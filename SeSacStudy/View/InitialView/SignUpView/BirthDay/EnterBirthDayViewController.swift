//
//  EnterBirthDayViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/10.
//

import UIKit


final class EnterBirthDayViewController: BaseViewController {
    
    // MARK: - Propertys
    var viewModel: SignUpViewModel?
    
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSS"
    }
    
    
    
    
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
            $0.reusableTextField.textField.inputView = customView.datePickerView
        }
    }
    
    
    private func bind() {
        customView.reusableView.button.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                let emailVC = EnterEmailViewController()
                emailVC.viewModel = vc.viewModel
                vc.transition(emailVC, transitionStyle: .push)
            }
            .disposed(by: disposeBag)
        
        
        customView.datePickerView.rx.date
            .withUnretained(self)
            .bind { (vc, date) in
                vc.viewModel?.signUp.birth = vc.dateFormatter.string(from: date)
                vc.updateUI(dy: date)
            }
            .disposed(by: disposeBag)
    }
    
    
    private func updateUI(dy date: Date) {
        let component = Calendar.current.dateComponents([.year, .month, .day], from: customView.datePickerView.date)
        customView.year.reusableTextField.textField.text = "\(component.year ?? 0)"
        customView.month.reusableTextField.textField.text = "\(component.month ?? 0)"
        customView.day.reusableTextField.textField.text = "\(component.day ?? 0)"
    }
}
