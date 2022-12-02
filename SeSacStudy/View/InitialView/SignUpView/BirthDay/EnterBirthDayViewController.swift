//
//  EnterBirthDayViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/10.
//

import UIKit


final class EnterBirthDayViewController: RxBaseViewController {
    
    // MARK: - Propertys
    private let viewModel = EnterBirthDayViewModel()
    
    private var dateValidation: Bool = false {
        didSet {
            if dateValidation == oldValue { return }
            customView.reusableView.button.setButtonStyle(status: dateValidation ? .fill : .cancel)
        }
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
        setInitialUI()

        bind()
    }
    
    
    private func setInitialUI() {
        customView.reusableView.textStackView.addText(title: "생년월일을 알려주세요")
        customView.reusableView.button.setTitle("다음", for: .normal)
        
        customView.textFields.forEach {
            $0.reusableTextField.textField.inputView = customView.datePickerView
            $0.reusableTextField.textField.tintColor = .clear
            $0.reusableTextField.lineView.backgroundColor = R.color.black()
        }
    }
    
    
    private func bind() {
        let input = EnterBirthDayViewModel.Input(buttonTap: customView.reusableView.button.rx.tap, birthday: customView.datePickerView.rx.date)
        let output = viewModel.transform(input: input)
        
        output.buttonTap
            .withUnretained(self)
            .bind { (vc, _) in
                if vc.dateValidation {
                    let emailVC = EnterEmailViewController()
                    vc.transition(emailVC, transitionStyle: .push)
                }else {
                    vc.showToast(message: "새싹스터디는 만 17세 이상만 사용할 수 있습니다.")
                }
            }
            .disposed(by: disposeBag)
        
        
        output.birthday
            .withUnretained(self)
            .bind { (vc, date) in
                SignUpModel.shared.add(birtyDay: vc.viewModel.convertToServerFormat(date))
                vc.updateUI(dy: date)
            }
            .disposed(by: disposeBag)
        
        
        output.validation
            .withUnretained(self)
            .bind { (vc, value) in
                vc.dateValidation = value
            }
            .disposed(by: disposeBag)
    }
    
    
    private func updateUI(dy date: Date) {
        let component = viewModel.convertToDateComponents(date)
        customView.year.reusableTextField.textField.text = "\(component.year ?? 0)"
        customView.month.reusableTextField.textField.text = "\(component.month ?? 0)"
        customView.day.reusableTextField.textField.text = "\(component.day ?? 0)"
    }
}
