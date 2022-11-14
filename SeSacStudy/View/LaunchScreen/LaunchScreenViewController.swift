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
        
        setRootViewController()
    }
    
    
    
    
    // MARK: - Methods
    private func setRootViewController() {
        
        changeRootViewController(to: UINavigationController(rootViewController: EnterNicknameViewController()))
        
        if UserDefaultManager.shared.idToken == "" {
            let vc = OnboardingViewController()
            changeRootViewController(to: vc)
            
        }
        else {
            requestUserInfo()
        }
    }
    
    
    private func requestUserInfo() {
        
        APIService.share.request(type: Login.self, router: .login) { [weak self] _, _, statusCode in
            switch statusCode {
            case 200:
                self?.changeRootViewController(to: MainTabBarController())
            case 406:
                self?.changeRootViewController(to: UINavigationController(rootViewController: EnterNicknameViewController()))
            case 401:
                FirebaseAuthManager.share.fetchIDToken { result in
                    switch result {
                    case .success(_):
                        self?.requestUserInfo()
                        return
                    case .failure(_):
                        self?.changeRootViewController(to: OnboardingViewController())
                    }
                }
            default:
                self?.changeRootViewController(to: OnboardingViewController())
            }
        }
    }
}
