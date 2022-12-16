//
//  RegisterReviewViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/12/07.
//

import UIKit


final class RegisterReviewViewController: RxBaseViewController {
    
    // MARK: - Propertys
    
    
    
    
    // MARK: - Life Cycle
    private let customView = RegisterReviewView(nick: DataStorage.shared.matchedUser.nick)
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        customView.sesacTitleView.buttons.forEach {
            $0.addTarget(self, action: #selector(sesacTitleButtonTapped), for: .touchUpInside)
        }
        
        customView.titleView.dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        
        bind()
    }
    
    
    private func bind() {
        customView.reviewTextView.rx.didBeginEditing
            .bind{ _ in
                if self.customView.reviewTextView.text == Placeholder.registerReview.rawValue {
                    self.customView.reviewTextView.text = ""
                }
                self.customView.reviewTextView.textColor = R.color.black()
            }.disposed(by: disposeBag)
        
        customView.reviewTextView.rx.didEndEditing
            .bind{
                if self.customView.reviewTextView.text.count == 0 {
                    self.customView.reviewTextView.text = Placeholder.registerReview.rawValue
                    self.customView.reviewTextView.textColor = R.color.gray7()
                }
            }.disposed(by: disposeBag)
        
        customView.registerReviewButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.requestRegisterReview()
            }
            .disposed(by: disposeBag)
    }
    
    
    private func requestRegisterReview() {
        let reputation = customView.sesacTitleView.buttons.map { $0.buttonStatus == .fill ? 1 : 0 }
        let review = RegisterReview(otheruid: DataStorage.shared.matchedUser.id, reputation: reputation, comment: customView.reviewTextView.text)
        APIService.share.request(router: .registerReview(review: review)) { [weak self] error, statusCode in
            switch statusCode {
            case 200: self?.changeRootViewController(to: MainTabBarController())
            case 401: FirebaseAuthManager.share.fetchIDToken { result in
                switch result {
                case .success(_): self?.requestRegisterReview()
                case .failure(let error): self?.showErrorAlert(error: error)
                }
            }
            case 406:
                self?.showAlert(title: "가입되지 않은 회원입니다. 초기화면으로 이동합니다.") { _ in
                    self?.changeRootViewController(to: OnboardingViewController())
                }
            case 500:
                print("Server Error")
            case 501:
                print("Client Error")
            default:
                print("Default")
            }
        }
    }
    
    
    @objc private func sesacTitleButtonTapped(_ button: BasicButton) {
        if button.buttonStatus == .inactive {
            button.setButtonStyle(status: .fill)
        }else {
            button.setButtonStyle(status: .inactive)
        }
    }
    
    
    @objc private func dismissButtonTapped() {
        dismiss(animated: true)
    }
}
