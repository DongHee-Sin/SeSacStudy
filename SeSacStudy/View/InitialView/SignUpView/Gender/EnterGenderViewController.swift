//
//  EnterGenderViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/10.
//

import UIKit


final class EnterGenderViewController: RxBaseViewController {
    
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
            }
            .disposed(by: disposeBag)

    }
    
    
    private func requestSignUp() {
        
        APIService.share.request(router: .signUp(body: SignUpModel.shared.model)) { [weak self] _, statusCode in

            switch statusCode {
            case 200:
                self?.showToast(message: "회원가입에 성공했습니다")
                let mainVC = MainTabBarController()
                self?.changeRootViewController(to: mainVC)
            case 201:
                self?.showToast(message: "이미 가입된 유저입니다")
            case 202:
                self?.showToast(message: "해당 닉네임은 사용할 수 없습니다")
                self?.transitionToNicknameVC()
            case 401:
                print("Firebase Id Token 만료")
                self?.fetchIdToken()
            case 500:
                self?.showAlert(title: "서버에 문제가 발생했습니다")
            case 501:
                self?.showAlert(title: "네트워크 통신에 실패했습니다")
            default:
                self?.showAlert(title: "네트워크 통신에 실패했습니다")
            }
        }
    }
    
    
    private func requestLogin() {
        
        APIService.share.request(type: Login.self, router: .login) { [weak self] result, _, statusCode in
            
            switch statusCode {
            case 200:
                if let result {
                    DataStorage.shared.updateInfo(info: result)
                }
                self?.changeRootViewController(to: MainTabBarController())
                
            case 406:
                self?.showAlert(title: "에러가 발생했습니다. 다시 시도해 주세요")
                
            case 401:
                FirebaseAuthManager.share.fetchIDToken { result in
                    switch result {
                    case .success(_):
                        self?.requestLogin()
                        return
                    case .failure(_):
                        self?.showAlert(title: "에러가 발생했습니다. 다시 시도해 주세요")
                    }
                }
                
            default:
                self?.showAlert(title: "에러가 발생했습니다. 다시 시도해 주세요")
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
