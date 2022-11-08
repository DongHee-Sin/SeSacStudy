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
        
//        customView.textField.delegate = self
    }
}
