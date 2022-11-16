//
//  CustomAlertViewController.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/16.
//

import UIKit


final class CustomAlertViewController: UIViewController {
    
    // MARK: - Propertys
    var delegate: CustomAlertDelegate?
    
    
    
    
    
    // MARK: - Life Cycle
    private let customView = CustomAlertView()
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    func configure(title: String, message: String) {
        customView.title.text = title
        customView.message.text = message
        
        customView.okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        customView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    
    @objc private func okButtonTapped() {
        delegate?.okAction()
    }
    
    
    @objc private func cancelButtonTapped() {
        delegate?.cancel()
    }
}
