//
//  LaunchScreenViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/11.
//

import UIKit


final class LaunchScreenViewController: UIViewController {
    
    // MARK: - Life Cycle
    private let customView = LaunchScreenView()
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //changeRootViewController(to: UINavigationController(rootViewController: ChattingViewController()))
        
        setRootViewController()
    }
    
    
    
    
    // MARK: - Methods
    private func setRootViewController() {
        
        if UserDefaultManager.shared.idToken == "" {
            let vc = OnboardingViewController()
            changeRootViewController(to: vc)
        }
        else {
            requestUserInfo()
        }
    }
    
    
    private func requestUserInfo() {
        
        APIService.share.request(type: Login.self, router: .login) { [weak self] result, error, statusCode in
            
            switch statusCode {
            case 200:
                if let result {
                    DataStorage.shared.updateInfo(info: result)
                    dump(result)
                }
                self?.changeRootViewController(to: MainTabBarController())
                
            case 406:
                self?.changeRootViewController(to: UINavigationController(rootViewController: EnterNicknameViewController()))
                
            case 401:
                FirebaseAuthManager.share.fetchIDToken { result in
                    switch result {
                    case .success(_):
                        self?.requestUserInfo()
                    case .failure(_):
                        self?.changeRootViewController(to: OnboardingViewController())
                    }
                }
                
            default:
                self?.showErrorAlert(error: error, completionHandler: { [weak self] _ in
                    self?.changeRootViewController(to: OnboardingViewController())
                })
            }
        }
    }
}
