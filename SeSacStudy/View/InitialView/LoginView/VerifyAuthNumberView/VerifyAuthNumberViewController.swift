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
    private let viewModel = VerifyAuthNumberViewModel()
    
    private var authNumberValidation: Bool = false {
        didSet {
            if authNumberValidation == oldValue { return }
            customView.reusableView.button.setButtonStyle(status: authNumberValidation ? .fill : .cancel)
        }
    }
    
    private var resendValidation: Bool = false {
        didSet {
            if resendValidation == oldValue { return }
            customView.resendButton.setButtonStyle(status: resendValidation ? .fill : .cancel)
        }
    }
    
    var verificationID: String?
    
    private var timer: Timer?
    
    
    
    
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
        
        customView.textField.delegate = self
        
        bind()
        timerStart()
    }
    
    
    private func bind() {
        let input = VerifyAuthNumberViewModel.Input(authNumberText: customView.textField.rx.text, resendTap: customView.resendButton.rx.tap, verifyTap: customView.reusableView.button.rx.tap)
        let output = viewModel.transform(input: input)
        
        
        viewModel.timerSecond
            .withUnretained(self)
            .bind { (vc, second) in
                if second == 50 {
                    vc.resendValidation = true
                }
                
                if second == 0 {
                    vc.stopTimer()
                    
                }
                
                vc.customView.timerLabel.text = "00:\(second)"
            }
            .disposed(by: disposeBag)
        
        
        output.isTextEntered.withUnretained(self)
            .bind { (vc, value) in
                vc.customView.lineView.backgroundColor = value ? R.color.black() : R.color.gray3()
            }
            .disposed(by: disposeBag)
        
        
        output.authNumberValidatoin
            .withUnretained(self)
            .bind { (vc, value) in
                vc.authNumberValidation = value
            }
            .disposed(by: disposeBag)
        
        
        output.resendTap.withUnretained(self)
            .bind { (vc, _) in
                if vc.resendValidation {
                    FirebaseAuthManager.share.requestAuthNumber { result in
                        switch result {
                        case .success(let id):
                            vc.verificationID = id
                            vc.timerStart()
                            vc.resendValidation = false
                        case .failure(let error):
                            vc.showAlert(title: "오류가 발생했습니다.", message: error.localizedDescription)
                        }
                    }
                }else {
                    vc.showAlert(title: "잠시 후 다시 시도해주세요", message: "인증문자는 10초에 한번 보낼 수 있습니다.")
                }
                
            }
            .disposed(by: disposeBag)
        
        
        output.verifyTap.withUnretained(self)
            .bind { (vc, _) in
                if vc.authNumberValidation && vc.viewModel.time != 0 {
                    FirebaseAuthManager.share.signIn(id: vc.verificationID ?? "", code: vc.customView.textField.text ?? "") { result in
                        switch result {
                        case .success(_):
                            vc.fetchIdToken()
                        case .failure(let error):
                            vc.showAlert(title: "인증에 실패했습니다", message: error.localizedDescription)
                        }
                    }
                }else {
                    vc.showAlert(title: "인증을 진행할 수 없습니다.", message: "인증번호의 유효시간이 끝났거나, 인증번호 6자리가 입력되지 않았습니다.")
                }
                
            }
            .disposed(by: disposeBag)
    }
}




// MARK: - Request Login
extension VerifyAuthNumberViewController {
    
    private func fetchIdToken() {
        
        FirebaseAuthManager.share.fetchIDToken { [weak self] result in
            switch result {
            case .success(_):
                self?.requestLogin()
            case .failure(let error):
                self?.showAlert(title: "인증에 실패했습니다", message: error.localizedDescription)
            }
        }
    }
    
    
    private func requestLogin() {
        
        APIService.share.request(type: Login.self, router: .login) { [weak self] value, error, statusCode in
            if let value {
                print("요청 성공")
                UserDefaultManager.shared.fcmToken = value.FCMtoken
            }
            
            if let error {
                self?.showErrorAlert(error: error)
                return
            }
            
            switch statusCode {
            case 401:
                print("Firebase Id Token 만료")
                self?.fetchIdToken()
            case 406:
                print("가입되지 않은 유저 -> 회원가입 화면으로 이동")
                let signupVC = EnterNicknameViewController()
                self?.transition(signupVC, transitionStyle: .push)
            case 500:
                self?.showAlert(title: "서버에 문제가 발생했습니다.", message: error?.localizedDescription)
            case 501:
                print("API 요청에 누락된 데이터가 있는지 확인 필요")
            default:
                self?.showAlert(title: "네트워크 통신에 실패했습니다.", message: error?.localizedDescription)
            }
        }
        
    }
    
}




// MARK: - TextField Delegate
extension VerifyAuthNumberViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }
        
        guard Int(string) != nil else {
            showToast(message: "숫자만 입력해주세요")
            return false
        }
        
        guard (textField.text ?? "").count < 6 else {
            showToast(message: "최대 6자리 숫자까지 입력할 수 있습니다")
            return false
        }
        
        return true
    }
}




// MARK: - Timer
extension VerifyAuthNumberViewController {
    
    private func timerStart() {
        
        if timer != nil && timer!.isValid {
            stopTimer()
        }
        
        viewModel.time = 60
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
        
    }
    
    
    @objc private func timerCallback() {
        viewModel.time -= 1
    }
    
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
}
