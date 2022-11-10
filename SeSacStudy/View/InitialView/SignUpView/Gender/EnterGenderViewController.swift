//
//  EnterGenderViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/10.
//

import UIKit


final class EnterGenderViewController: BaseViewController {
    
    // MARK: - Propertys
    
    
    
    
    // MARK: - Life Cycle
    private let customView = EnterGenderView()
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        customView.reusableView.textStackView.addText(title: "성별을 선택해 주세요", subTitle: "새싹 찾기 기능을 이용하기 위해서 필요해요!")
        customView.reusableView.button.setTitle("다음", for: .normal)
        
        bind()
    }
    
    
    private func bind() {
        // 1. 버튼 클릭
        // 2. VM의 값 변경
    }
}
