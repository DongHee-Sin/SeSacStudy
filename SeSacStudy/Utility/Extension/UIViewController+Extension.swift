//
//  UIViewController+Extension.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/08.
//

import UIKit


extension UIViewController {
    
    // MARK: - Transition
    enum TransitionStyle {
        case present
        case presentOver
        case push
    }
    
    
    func transition<T: UIViewController>(_ viewController: T, transitionStyle: TransitionStyle = .present, completion: (() -> Void)? = nil) {
        
        guard NetworkMonitor.shared.isConnected else {
            showAlert(title: "네트워크에 연결되어있지 않습니다.")
            return
        }
        
        switch transitionStyle {
        case .present:
            present(viewController, animated: true, completion: completion)
        case .presentOver:
            viewController.modalPresentationStyle = .overFullScreen
            present(viewController, animated: true, completion: completion)
        case .push:
            navigationController?.pushViewController(viewController, animated: true, completion: completion)
        }
    }
    
    
    
    
    // MARK: - Root VC
    func changeRootViewController(to rootVC: UIViewController) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        sceneDelegate?.window?.rootViewController = rootVC
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    
    
    
    // MARK: - Alert
    typealias CompletionHandler = (UIAlertAction) -> Void
    
    func showAlert(title: String, message: String? = nil, buttonTitle: String = "확인", cancelTitle: String? = nil, completionHandler: CompletionHandler? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: buttonTitle, style: .default, handler: completionHandler)
        
        if let cancelTitle = cancelTitle {
            let cancelButton = UIAlertAction(title: cancelTitle, style: .destructive)
            alertController.addAction(cancelButton)
        }
        
        alertController.addAction(okButton)
        
        present(alertController, animated: true)
    }
    
    
    
    
    // MARK: - Error Alert
    func showErrorAlert(error: Error? = nil, completionHandler: CompletionHandler? = nil) {
        guard let error else { showAlert(title: "에러가 발생했습니다. 잠시 후 다시 시도해주세요."); return }
        
        switch error {
        case NetworkError.notConnected: showAlert(title: "네트워크에 연결되어있지 않습니다.", completionHandler: completionHandler)
        default: showAlert(title: "에러가 발생했습니다. 잠시 후 다시 시도해주세요.", completionHandler: completionHandler)
        }
    }
    
    
    
    
    // MARK: - Custom Alert
    func showCustomAlert(title: String, message: String, delegate: CustomAlertDelegate) {
        let customAlertVC = CustomAlertViewController()
        customAlertVC.delegate = delegate
        customAlertVC.configure(title: title, message: message)
        
        transition(customAlertVC, transitionStyle: .presentOver)
    }
    
    
    
    
    // MARK: - Toast
    func showToast(message: String, target: NSLayoutYAxisAnchor? = nil, offset: Double? = -12, completion: (() -> Void)? = nil) {
        view.subviews
            .filter { $0.tag == 936419836287461 }
            .forEach { $0.removeFromSuperview() }
        
        let alertSuperview = UIView()
        alertSuperview.tag = 936419836287461
        alertSuperview.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        alertSuperview.layer.cornerRadius = 10
        alertSuperview.isHidden = true
        alertSuperview.translatesAutoresizingMaskIntoConstraints = false
        
        let alertLabel = UILabel()
        alertLabel.font = .customFont(.body3_R14)
        alertLabel.textColor = .white
        alertLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(alertSuperview)
        alertSuperview.bottomAnchor.constraint(equalTo: target ?? view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        alertSuperview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        alertSuperview.addSubview(alertLabel)
        alertLabel.topAnchor.constraint(equalTo: alertSuperview.topAnchor, constant: 6).isActive = true
        alertLabel.bottomAnchor.constraint(equalTo: alertSuperview.bottomAnchor, constant: -6).isActive = true
        alertLabel.leadingAnchor.constraint(equalTo: alertSuperview.leadingAnchor, constant: 12).isActive = true
        alertLabel.trailingAnchor.constraint(equalTo: alertSuperview.trailingAnchor, constant: -12).isActive = true
        
        alertLabel.text = message
        alertSuperview.alpha = 1.0
        alertSuperview.isHidden = false
        UIView.animate(
            withDuration: 2.0,
            delay: 1.0,
            options: .curveEaseIn,
            animations: { alertSuperview.alpha = 0 },
            completion: { _ in
                alertSuperview.removeFromSuperview()
                completion?()
            }
        )
    }
}




// MARK: - API
//extension UIViewController {
//
//    func statusCodeHandling(type: Router, code: Int) {
//        switch type {
//        case .login:
//            guard let code = StatusCode.Common(rawValue: code) else { showErrorAlert() }
//        case .signUp(let body):
//            <#code#>
//        case .mypage(let body):
//            <#code#>
//        case .withdraw:
//            <#code#>
//        case .queueStatus:
//            <#code#>
//        case .queueSearch:
//            <#code#>
//        case .requestSearch(let list):
//            <#code#>
//        case .cancelRequestSearch:
//            <#code#>
//        case .requestStudy(let uid):
//            <#code#>
//        case .acceptStudy(let uid):
//            <#code#>
//        }
//    }
//}
