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
        let input = EnterGenderViewModel.Input(buttonTap: customView.reusableView.button.rx.tap, manButtonTap: customView.manButton.rx.tap, womanButtonTap: customView.womanButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        
        output.buttonTap
            .drive(onNext: { [weak self] _ in
                guard let self else { return }
                if self.customView.reusableView.button.buttonStatus == .fill {
                    self.requestSignUp()
                }else {
                    self.showToast(message: "성별을 선택해주세요")
                }
            })
            .disposed(by: disposeBag)
        
        
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
                SignUpModel.shared.add(gender: gender)
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
    
    
    private func requestSignUp() {
        
        APIService.share.request(router: .SignUp(body: SignUpModel.shared.model)) { [weak self] error, statusCode in
            if let error {
                self?.showErrorAlert(error: error)
                return
            }

            switch statusCode {
            case 200:
                print("회원가입 성공")
                let mainVC = MainTabBarController()
                self?.changeRootViewController(to: mainVC)
            case 201:
                print("이미 가입된 유저")
                self?.showToast(message: "이미 가입된 유저입니다")
            case 202:
                print("사용할 수 없는 닉네임")
                self?.transitionToNicknameVC()
                let controller = self?.navigationController?.viewControllers[(self?.navigationController?.viewControllers.count)! - 3]
                self?.navigationController?.popToViewController(controller!, animated: true)
            case 401:
                print("Firebase Id Token 만료")
                self?.fetchIdToken()
            case 500:
                self?.showAlert(title: "서버에 문제가 발생했습니다.", message: error?.localizedDescription)
            case 501:
                print("API 요청에 누락된 데이터가 있는지 확인 필요")
            default:
                self?.showAlert(title: "네트워크 통신에 실패했습니다.", message: error?.localizedDescription)
            }
        }
    }
    
    
    private func fetchIdToken() {
        
        FirebaseAuthManager.share.fetchIDToken { [weak self] result in
            switch result {
            case .success(_):
                self?.requestSignUp()
            case .failure(let error):
                self?.showAlert(title: "인증에 실패했습니다", message: error.localizedDescription)
            }
        }
    }
    
    
    private func transitionToNicknameVC() {
        let controller = navigationController?.viewControllers[(navigationController?.viewControllers.count)! - 4]
        navigationController?.popToViewController(controller!, animated: true)
    }
}
