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
        case push
    }
    
    
    func transition<T: UIViewController>(_ viewController: T, transitionStyle: TransitionStyle = .present) {
        
        switch transitionStyle {
        case .present:
            self.present(viewController, animated: true)
        case .push:
            self.navigationController?.pushViewController(viewController, animated: true)
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
    
    func showAlert(title: String, buttonTitle: String = "확인", cancelTitle: String? = nil, completionHandler: CompletionHandler? = nil) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: buttonTitle, style: .default, handler: completionHandler)
        
        if let cancelTitle = cancelTitle {
            let cancelButton = UIAlertAction(title: cancelTitle, style: .destructive)
            alertController.addAction(cancelButton)
        }
        
        alertController.addAction(okButton)
        
        present(alertController, animated: true)
    }
    
}
