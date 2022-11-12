//
//  EnterGenderViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/10.
//

import UIKit


final class EnterGenderViewController: BaseViewController {
    
    // MARK: - Propertys
    private let viewModel = EnterGenderViewModel()
    
    
    
    
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
        setInitialUI()
        
        bind()
    }
    
    
    private func setInitialUI() {
        customView.reusableView.textStackView.addText(title: "성별을 선택해 주세요", subTitle: "새싹 찾기 기능을 이용하기 위해서 필요해요!")
        customView.reusableView.button.setTitle("다음", for: .normal)
    }
    
    
    private func bind() {
        let input = EnterGenderViewModel.Input(manButtonTap: customView.manButton.rx.tap, womanButtonTap: customView.womanButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        
        output.manButtonTap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.viewModel.selectedGender.accept(.man)
            }
            .disposed(by: disposeBag)
        
        
        output.womanButtonTap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.viewModel.selectedGender.accept(.woman)
            }
            .disposed(by: disposeBag)
        
        
        viewModel.selectedGender
            .withUnretained(self)
            .bind { (vc, gender) in
                vc.customView.manButton.backgroundColor = gender == .man ? R.color.whitegreen() : R.color.white()
                vc.customView.womanButton.backgroundColor = gender == .woman ? R.color.whitegreen() : R.color.white()
            }
            .disposed(by: disposeBag)
        
        
        viewModel.selectedGender
            .take(1)
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.customView.reusableView.button.setButtonStyle(status: .fill)
            } onDisposed: {
                print("dispose!!!!!!!!!")
            }
            .disposed(by: disposeBag)

    }
}
