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
        
        customView.reusableView.textStackView.addText(title: "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해 주세요")
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        bind()
    }
    
    
    private func bind() {
        /// 할일
        /// 1. bind 시킬 작업들 리스트업
        /// 2. 뷰모델에 input/output 적용
        /// 3. 작업
        
        customView.textField.rx.text.orEmpty
            .bind(to: viewModel.phoneNumber)
            .disposed(by: disposeBag)
        
        
        viewModel.phoneNumber
            .map { $0.count >= 1 }
            .withUnretained(self)
            .bind { (vc, value) in
                vc.customView.lineView.backgroundColor = value ? R.color.black() : R.color.gray3()
            }
            .disposed(by: disposeBag)
    }
}
